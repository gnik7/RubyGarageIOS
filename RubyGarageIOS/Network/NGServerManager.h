//
//  NGServerManager.h
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 09.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NGDetailProduct;
@class NGPagination;

@interface NGServerManager : NSObject

+ (NGServerManager*) sharedManager;

- (void) getCategoriesOnSuccess:(void(^)(NSArray* category))success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getProductsWithOffset:(NSInteger) limit currentPage:(NSInteger) page  categoryName:(NSString *) category_name searchString:(NSString *) string onSuccess:(void(^)(NSArray* products, NGPagination* pagination))success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getProductDetail:(NSInteger) idProduct onSuccess:(void(^)(NGDetailProduct* product))success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


+ (void) alertMessage:(NSString*)message;
+ (BOOL) isConnectedToNetwork;

@end
