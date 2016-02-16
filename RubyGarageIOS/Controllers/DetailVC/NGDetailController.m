//
//  NGDetailController.m
//  RubyGarageIOS
//
//  Created by comp23 on 2/13/16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "NGDetailController.h"
#import "NGServerManager.h"
#import "NGDetailProduct.h"
#import "NGProductsCollection.h"
#import "NGProducts.h"
#import "NGCategory.h"
#import "NGProgress.h"
#import "ImageSaver.h"
#import "NGFavoriteController.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "ProductSelected.h"

#import "MagicalRecord.h"


@interface NGDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *titleProduct;
@property (weak, nonatomic) IBOutlet UITextView *descriptionProduct;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveDeleteButton;



@property (strong, nonatomic) NGDetailProduct *productInfo;

@property (strong, nonatomic) NGProgress *progress;

@end

@implementation NGDetailController

#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progress = [[NGProgress alloc] init];
    
    self.productInfo = [[NGDetailProduct alloc] init];
    
    [self.saveDeleteButton setTitle:self.titleSaveDeleteButton forState:UIControlStateNormal];
    [self.saveDeleteButton setTitle:self.titleSaveDeleteButton forState:UIControlStateSelected];
    
    
    self.titleProduct.text = @"";
    self.descriptionProduct.text = @"";
    self.priceLabel.text = @"";

    
    if ([self.titleSaveDeleteButton isEqualToString:@"DELETE"] && self.productSelected != nil) {
        self.titleProduct.text = self.productSelected.product_title;
        self.descriptionProduct.text = self.productSelected.product_description;
        self.priceLabel.text = self.productSelected.product_price;
        if (self.productSelected.imageUrl.length > 0) {
            
            NSData *imgData = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:self.productSelected.imageUrl]];
            self.imageProduct.image = [UIImage imageWithData:imgData];
        } else {
            self.imageProduct.image = [UIImage imageNamed: @"placeholder.png"];
        }

    }
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    if ([self.titleSaveDeleteButton isEqualToString:@"SAVE"]) {
        if ([NGServerManager isConnectedToNetwork]) {
            [self.progress createProgressHUDOn];
            [[NGServerManager sharedManager] getProductDetail:self.product_id
                                                    onSuccess:^(NGDetailProduct *prdt) {
                                                        
                                                        self.productInfo = prdt;
                                                        self.titleProduct.text = prdt.product_title;
                                                        self.descriptionProduct.text = prdt.product_description;
                                                        self.priceLabel.text = prdt.product_price;
                                                        
                                                        __weak UIImageView *weakImageV = self.imageProduct;
                                                        
                                                        [self.imageProduct sd_setImageWithURL:prdt.imageUrl
                                                                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                                                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                                        
                                                                                        if (image != nil) {
                                                                                            weakImageV.image = image;
                                                                                            [weakImageV layoutSubviews];
                                                                                        }
                                                                                        if (error) {
                                                                                            NSLog(@"Error: %@", error.description);
                                                                                        }
                                                                                    }];
                                                        [self.progress hideProgressHUD];
                                                        [self.view setNeedsDisplay];
                                                        
                                                    }
                                                    onFailure:^(NSError *error, NSInteger statusCode) {
                                                        NSLog(@"%@", error.localizedDescription);
                                                        [self.progress hideProgressHUD];
                                                    } ];
            
            
        } else {
            [NGServerManager alertMessage:@"No internet connection or service ton avalible"];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (IBAction)saveDeleteAction:(UIButton *)sender {
    
    if ([self.titleSaveDeleteButton isEqualToString:@"SAVE"]) {
        [self saveContext];
        
    } else if ([self.titleSaveDeleteButton isEqualToString:@"DELETE"]) {
        [self deleteFavorite];
    }
    
}
- (IBAction)cancelAction:(UIButton *)sender {
    
    if ([self.titleSaveDeleteButton isEqualToString:@"SAVE"]) {
        [self moveToCollection];
        
        
    } else if ([self.titleSaveDeleteButton isEqualToString:@"DELETE"]) {
        [self moveToFavorite];
    }

}


#pragma mark - Core Data

- (void)saveContext {

    ProductSelected *prs = [ProductSelected MR_createEntity];
    
    prs.product_title = self.titleProduct.text;
    prs.product_price = self.priceLabel.text;
    prs.product_description = self.descriptionProduct.text;
    prs.product_id = self.productInfo.product_id;
    [ImageSaver saveImageToDisk:self.imageProduct.image andToProduct:prs];
    
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave) {
            NSLog(@"You successfully saved your context.");
            [self moveToCollection];
            
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
        
    }];
    
}


- (void) moveToCollection {
//    NGProductsCollection *controler = [self.storyboard instantiateViewControllerWithIdentifier:@"NGProductsCollection"];
//
//    controler.category = self.category;
//    controler.searchProducts = self.searchString;
//    
//    [controler setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    [self presentViewController:controler animated:YES completion:nil];
    
    NGProductsCollection *controler = [self.storyboard instantiateViewControllerWithIdentifier:@"NGProductsCollection"];
    
    controler.category = self.category;
    controler.searchProducts = self.searchString;
    controler.hidesBottomBarWhenPushed = true;
    
    [self dismissViewControllerAnimated:true completion:^{
        [self presentViewController:controler animated:YES completion:^{
            
        }];
    }];


}

- (void) deleteFavorite {

 
    if (self.productSelected.imageUrl.length > 0) {
        [ImageSaver deleteImageAtPath:self.productSelected.imageUrl];
    }
    
    [self.productSelected MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave) {
            NSLog(@"You successfully saved your context.");
            [self moveToFavorite];
            
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
        
    }];
}

- (void) moveToFavorite {
    NGFavoriteController *controler = [self.storyboard instantiateViewControllerWithIdentifier:@"NGFavoriteController"];
    controler.hidesBottomBarWhenPushed = true;
   
    [self dismissViewControllerAnimated:true completion:^{
        [self presentViewController:controler animated:YES completion:^{
            
        }];
    }];
       
}


@end
