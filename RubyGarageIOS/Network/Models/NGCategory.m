//
//  NGCategory.m
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 09.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "NGCategory.h"


@implementation NGCategory


- (id) initWithServerResponce:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        self.category_id = [responseObject objectForKey:@"category_id"];
        self.category_name = [responseObject objectForKey:@"category_name"];
        self.long_name = [responseObject objectForKey:@"long_name"];
        
    }
    return self;
}



@end
