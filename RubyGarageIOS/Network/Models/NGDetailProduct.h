//
//  NGDetailProduct.h
//  RubyGarageIOS
//
//  Created by comp23 on 2/13/16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGDetailProduct : NSObject

@property (strong, nonatomic) NSNumber *product_id;
@property (strong, nonatomic) NSString *product_description;
@property (strong, nonatomic) NSString *product_title;
@property (strong, nonatomic) NSString *product_price;
@property (strong, nonatomic) NSURL *imageUrl;

- (id) initWithServerResponce:(NSDictionary*) responseObject;





@end
