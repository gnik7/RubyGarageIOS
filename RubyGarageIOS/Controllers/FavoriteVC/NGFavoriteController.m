//
//  NGFavoriteController.m
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 14.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "NGFavoriteController.h"
#import "NGDetailController.h"
#import "NGServerManager.h"
#import "NGProducts.h"
#import "NGProductCell.h"
#import "NGCategory.h"
#import "NGPagination.h"
#import "NGProgress.h"

#import "ProductSelected.h"
#import "MagicalRecord.h"

@interface NGFavoriteController ()

@property (strong, nonatomic) NSMutableArray *favoriteArray;
@property (weak, nonatomic) IBOutlet UICollectionView *favoriteCollection;
@property (weak, nonatomic) IBOutlet UITabBarItem *tapBarIt;


@end

static NSString * const reuseIdentifier = @"NGProductCell";


@implementation NGFavoriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.favoriteCollection.delegate = self;
    self.favoriteCollection.dataSource = self;
    
    [self setUpBegin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.alpha = 0.0;
    [UIView animateWithDuration:.3 animations:^{
        self.tabBarController.tabBar.alpha = 5.0;
    }];
    
    [self setUpBegin];
}

- (void) setUpBegin {
    self.favoriteArray = [NSMutableArray array];
    
    NSNumber *count = [ProductSelected MR_numberOfEntities];
    NSLog(@"%@", count);
    
    if ([count integerValue] > 0) {
        NSArray *prodArray = [NSArray arrayWithArray:[ProductSelected MR_findAll]];
        self.favoriteArray = [NSMutableArray arrayWithArray:prodArray];
    }
    [self.favoriteCollection reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.favoriteArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NGProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([self.favoriteArray count] > 0 ){
        ProductSelected *pr = [self.favoriteArray objectAtIndex:indexPath.row];
        cell.productTitle.text = pr.product_title;
        cell.tag = [pr.product_id integerValue];
        if (pr.imageUrl.length > 0) {
             NSData *imgData = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:pr.imageUrl]];
             cell.productImage.image = [UIImage imageWithData:imgData];
        }      
 
        cell.layer.borderWidth = 2.0;
        cell.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor;
        cell.layer.cornerRadius = 5.0;
        cell.clipsToBounds = true;
        
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
    
    
    NGDetailController *vc = (NGDetailController*)[self.storyboard instantiateViewControllerWithIdentifier: @"NGDetailController"];
    vc.productSelected = [self.favoriteArray objectAtIndex:indexPath.row];
    vc.titleSaveDeleteButton = @"DELETE";
    self.hidesBottomBarWhenPushed = YES;

    [self presentViewController:vc animated:true completion:nil];
    
}


@end
