//
//  NGCategory.h
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 09.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGCategory : NSObject


@property (strong, nonatomic) NSNumber *category_id;
@property (strong, nonatomic) NSString *category_name;
@property (strong, nonatomic) NSString *long_name;

- (id) initWithServerResponce:(NSDictionary*) responseObject;


@end
