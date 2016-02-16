//
//  NGProductCell.h
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 10.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NGProductCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UITextView *productTitle;

@end
