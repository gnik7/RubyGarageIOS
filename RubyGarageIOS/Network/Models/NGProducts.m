//
//  NGProducts.m
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 10.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "NGProducts.h"
#import <UIKit/UIKit.h>

@implementation NGProducts


- (id) initWithServerResponce:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        self.product_name = [self convertHtmlString:[responseObject objectForKey:@"title"]];
        self.product_id = [responseObject objectForKey:@"listing_id"];
        
        NSDictionary *imagePath = [responseObject objectForKey:@"MainImage"];
        if ([imagePath count] > 0)
        {
            NSString * url = [imagePath objectForKey:@"url_570xN"];
            self.imageUrl = [NSURL URLWithString:url];
        }
        
    }
    return self;
}


- (NSString*) convertHtmlString:(NSString*) string {
    
    if ([string containsString:@"&#39;"]) {
        NSString *tmp = [string stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        return tmp;
    } else if ([string containsString:@"&quot;"]) {
        NSString *tmp = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        return tmp;
    }
    else {
        return string;
    }
    
}


@end
