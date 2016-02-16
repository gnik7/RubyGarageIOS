//
//  NGProducts.h
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 10.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGProducts : NSObject

@property (strong, nonatomic) NSNumber *product_id;
@property (strong, nonatomic) NSString *product_name;
@property (strong, nonatomic) NSURL *imageUrl;

- (id) initWithServerResponce:(NSDictionary*) responseObject;



@end
