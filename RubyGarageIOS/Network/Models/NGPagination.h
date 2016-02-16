//
//  NGPagination.h
//  RubyGarageIOS
//
//  Created by comp23 on 2/13/16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGPagination : NSObject

@property(assign, nonatomic) NSInteger count;
@property(assign, nonatomic) NSInteger next_page;
@property(assign, nonatomic) NSInteger next_offset;
@property(assign, nonatomic) NSInteger current_page;
@property(assign, nonatomic) BOOL isNextPageExist;


- (id) initWithServerResponce:(NSDictionary*) responseObject;

@end
