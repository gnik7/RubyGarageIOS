//
//  NGProductsCollection.h
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 10.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NGCategory;
@interface NGProductsCollection : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property(strong, nonatomic) NSString *searchProducts;
@property(strong, nonatomic) NGCategory *category;


@end
