//
//  NGServerManager.m
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 09.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "NGServerManager.h"
#import "AFNetworking.h"
#import "NGCategory.h"
#import "NGProducts.h"
#import "NGDetailProduct.h"
#import "NGPagination.h"



@interface NGServerManager()

@property (strong, nonatomic) AFHTTPSessionManager *requestOperationManager;

@end

static NSString * const api_key = @"?api_key=l6pdqjuf7hdf97h1yvzadfce";

@implementation NGServerManager

+ (NGServerManager*) sharedManager
{
    static NGServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NGServerManager alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL *url = [NSURL URLWithString:@"https://openapi.etsy.com/v2/"];
        self.requestOperationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}


// Get Category

- (void) getCategoriesOnSuccess:(void(^)(NSArray* category))success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString *path = [NSString stringWithFormat:@"%@%@", @"taxonomy/categories", api_key];
    [self.requestOperationManager GET:path
                           parameters:nil
                             progress:nil
                              success:^(NSURLSessionTask *task, id responseObject) {
                                  
                                  NSLog(@"JSON: %@", responseObject);
                                  
                                  NSArray *dictsArray = [responseObject objectForKey:@"results"];
                                  NSMutableArray *objectsArray = [NSMutableArray array];
                                  for (NSDictionary *dict in dictsArray) {
                                      NGCategory *category = [[NGCategory alloc] initWithServerResponce:dict];
                                      [objectsArray addObject:category];
                                  }
                                  if (success) {
                                      success(objectsArray);
                                  }
                                  
                                  
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

// Get Products

- (void) getProductsWithOffset:(NSInteger) limit currentPage:(NSInteger) page  categoryName:(NSString *) category_name searchString:(NSString *) string onSuccess:(void(^)(NSArray* products, NGPagination* pagination))success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString *path = [NSString stringWithFormat:@"%@%@", @"listings/active", api_key];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            string,     @"keywords",
                            category_name,    @"category",
                            @"MainImage(url_570xN)",   @"includes",
                            @(limit),   @"limit",
                            @(page),   @"page"
                            
                            , nil];
    
    [self.requestOperationManager GET:path
                           parameters:params
                             progress:nil
                              success:^(NSURLSessionTask *task, id responseObject) {
                                  
                                  NSLog(@"JSON: %@", responseObject);
                                  NSArray *dictsArray = [NSArray array];
                                  NSMutableArray *objectsArray = [NSMutableArray array];
                                  
                                  if ([responseObject objectForKey:@"results"] !=nil) {
                                      
                                      dictsArray = [NSArray arrayWithArray:[responseObject objectForKey:@"results"]];                                      
                                      for (NSDictionary *dict in dictsArray) {
                                          NGProducts *category = [[NGProducts alloc] initWithServerResponce:dict];
                                          [objectsArray addObject:category];
                                      }
                                  }
                                  
                                  NSDictionary *paginDict = [responseObject objectForKey:@"pagination"];
                                  NGPagination *paginationObj = [[NGPagination alloc] initWithServerResponce:paginDict];

                                  paginationObj.count = [[responseObject objectForKey:@"count"] integerValue];

                                  if (success) {
                                      success(objectsArray, paginationObj);
                                  }
                                  
                                  
                              } failure:^(NSURLSessionTask *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                              }];    
}


// Get Detail

- (void) getProductDetail:(NSInteger) idProduct onSuccess:(void(^)(NGDetailProduct* product))success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString *path = [NSString stringWithFormat:@"%@%ld%@", @"listings/",idProduct, api_key];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:

                            @"MainImage(url_570xN)",   @"includes"
                            , nil];
    
    [self.requestOperationManager GET:path
                           parameters:params
                             progress:nil
                              success:^(NSURLSessionTask *task, id responseObject) {
                                  
                                  NSLog(@"JSON: %@", responseObject);
                                  NSArray *dictsArray = [responseObject objectForKey:@"results"];
                                  
                                  NSDictionary *dict = dictsArray[0];
                                  NGDetailProduct *product = [[NGDetailProduct alloc] initWithServerResponce:dict];

                                  if (success) {
                                      success(product);
                                  }
                                  
                                  
                              } failure:^(NSURLSessionTask *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                              }];
}


+ (void) alertMessage:(NSString*)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Info"
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{}];

}

+ (BOOL) isConnectedToNetwork {
    
    __block BOOL status = false;
    NSURL *url = [NSURL URLWithString:@"https://etsy.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    request.HTTPMethod = @"HEAD";
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (response) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if ([httpResponse statusCode] == 200) {
                status = true;
            }
        }
        
    }] resume];
    
    
    return true;
}



@end