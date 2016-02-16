//
//  NGProductsCollection.m
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 10.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "NGProductsCollection.h"
#import "NGDetailController.h"
#import "NGServerManager.h"
#import "NGProducts.h"
#import "NGProductCell.h"
#import "NGCategory.h"
#import "NGPagination.h"
#import "NGProgress.h"
#import "SearchViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface NGProductsCollection ()


@property (strong, nonatomic) IBOutlet UICollectionView *productsCollection;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) NSMutableArray *productsArray;
@property (strong, nonatomic) NGPagination *page;

@property (strong, nonatomic) NGProgress *progress;

@end

@implementation NGProductsCollection

static NSString * const reuseIdentifier = @"NGProductCell";
static const NSInteger collectionsInPage = 16;

#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progress = [[NGProgress alloc] init];
    
    self.navBar.topItem.title = self.category.long_name;
    
    self.productsCollection.delegate = self;
    self.productsCollection.dataSource = self;
    
    
    self.productsArray = [NSMutableArray array];
    
    self.page = [[NGPagination alloc] init];
    self.page.current_page = 1;
    self.page.count = 0;
    self.page.isNextPageExist = true;

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    if ([NGServerManager isConnectedToNetwork]) {
        
        [self getListingonPage: self.page.current_page];
    } else {
        [NGServerManager alertMessage:@"No internet connection or service ton avalible"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API Call

- (void) getListingonPage:(NSInteger)pageN {
    
    NSInteger viewInPage = 0;
    
    if (self.page.count == 0) {
        viewInPage = collectionsInPage;
    } else {
            viewInPage = self.page.next_offset;
    }
    if (!self.page.isNextPageExist) {
        return;
    }
    [self.progress createProgressHUDOn];
    [[NGServerManager sharedManager] getProductsWithOffset:viewInPage
                                               currentPage:pageN
                                              categoryName:self.category.category_name
                                              searchString:[self.searchProducts lowercaseString] onSuccess:^(NSArray *products, NGPagination* pagination) {
                                                  
                                                  if ([products count] > 0) {
                                                      [self.productsArray addObjectsFromArray:products];
                                                      [self.productsCollection reloadData];
                                                      
                                                      self.page.next_offset = pagination.next_offset;
                                                      self.page.count = pagination.count;
                                                      self.page.next_page = pagination.next_page;
                                                      self.page.current_page = pagination.current_page;
                                                      self.page.isNextPageExist = pagination.isNextPageExist;
                                                      
                                                      
                                                  } else if (!self.page.isNextPageExist) {
                                                      return ;
                                                  } else if ([products count] == 0 && !self.page.isNextPageExist) {
                                                      [NGServerManager alertMessage:@"Wrong phrase to search"];
                                                  }
                                                  [self.progress hideProgressHUD];
                                                  
                                              } onFailure:^(NSError *error, NSInteger statusCode) {
                                                  [self.progress hideProgressHUD];
                                              }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.productsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NGProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([self.productsArray count] > 0 && indexPath.row < [self.productsArray count] - 1) {
        NGProducts *pr = [self.productsArray objectAtIndex:indexPath.row];
        cell.productTitle.text = pr.product_name;
        cell.tag = [pr.product_id integerValue];

        __weak NGProductCell *weakCell = cell;
        //cell.productImage.image = nil;
        
        [cell.productImage sd_setImageWithURL:pr.imageUrl
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        
                                        if (image != nil) {
                                             weakCell.productImage.image = image;
                                            [weakCell layoutSubviews];
                                        }
                                        if (error) {
                                            NSLog(@"Error: %@", error.description);
                                        }
                             }];
        
        cell.layer.borderWidth = 2.0;
        cell.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor;
        cell.layer.cornerRadius = 5.0;
        cell.clipsToBounds = true;
        
    } else  if (indexPath.row == [self.productsArray count] - 1){
        NSLog(@"END--------");
        if (self.page.current_page != self.page.next_page) {
            if ([NGServerManager isConnectedToNetwork]) {
                [self getListingonPage: self.page.next_page];
            } else {
                [NGServerManager alertMessage:@"No internet connection or service ton avalible"];
            }
        }
        
    }
    
    
    
    
    
    return cell;
}

#pragma mark  - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width * 0.45, self.view.frame.size.width * 0.45 * 1.5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2.0;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(4, 4, 4, 4); // top, left, bottom, right
}




#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NGProducts *pr = [self.productsArray objectAtIndex:indexPath.row];
    
    NGDetailController *vc = (NGDetailController*)[self.storyboard instantiateViewControllerWithIdentifier: @"NGDetailController"];
    vc.product_id = [pr.product_id integerValue];
    vc.category = self.category;
    vc.searchString = self.searchProducts;
    vc.titleSaveDeleteButton = @"SAVE";
    [self presentViewController:vc animated:true completion:nil];
    
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     //__block UIViewController *controller = segue.destinationViewController;
     
     if ([segue.identifier isEqual: @"BackToSearch"]) {
         SearchViewController *controler = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
         controler.hidesBottomBarWhenPushed = true;
         
         [self dismissViewControllerAnimated:true completion:^{
             [self presentViewController:controler animated:YES completion:^{
                 
             }];
         }];
     }
     
 }



@end
