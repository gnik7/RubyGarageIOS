//
//  NGPagination.m
//  RubyGarageIOS
//
//  Created by comp23 on 2/13/16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "NGPagination.h"

@implementation NGPagination


- (id) initWithServerResponce:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.next_offset = 0;
        self.next_page = 0;
        self.isNextPageExist = false;
        
        if ([responseObject objectForKey:@"next_page"] != [NSNull null]) {
            self.next_page = [[responseObject objectForKey:@"next_page"] integerValue];
            self.isNextPageExist = true;
        }
        if ([responseObject objectForKey:@"next_offset"] != [NSNull null] ) {
          self.next_offset = [[responseObject objectForKey:@"next_offset"] integerValue];
        }
        
        self.current_page = [[responseObject objectForKey:@"effective_page"] integerValue];

    }
    return self;
}


@end
