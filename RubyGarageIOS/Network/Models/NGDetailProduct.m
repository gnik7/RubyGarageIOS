//
//  NGDetailProduct.m
//  RubyGarageIOS
//
//  Created by comp23 on 2/13/16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "NGDetailProduct.h"

@implementation NGDetailProduct


- (id) initWithServerResponce:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
                
        self.product_id = [responseObject objectForKey:@"listing_id"];
        self.product_description = [self convertHtmlString:[responseObject objectForKey:@"description"]];
        self.product_title = [self convertHtmlString:[responseObject objectForKey:@"title"]];
        NSString *price = [responseObject objectForKey:@"price"];
        NSString *currency = [responseObject objectForKey:@"currency_code"];
        self.product_price = [NSString stringWithFormat: @"%@: %@", currency, price];
        
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
