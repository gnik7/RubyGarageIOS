//
//  NGDetailController.h
//  RubyGarageIOS
//
//  Created by comp23 on 2/13/16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NGCategory;
@class ProductSelected;

@interface NGDetailController : UIViewController


@property(assign, nonatomic) NSInteger product_id;

@property(strong, nonatomic) NGCategory *category;
@property(strong, nonatomic) NSString  *searchString;

@property(strong, nonatomic) ProductSelected *productSelected;

@property(strong, nonatomic) NSString *titleSaveDeleteButton;

@end







