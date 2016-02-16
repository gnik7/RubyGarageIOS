//
//  ImageSaver.h
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 15.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductSelected;

@interface ImageSaver : NSObject

+ (BOOL)saveImageToDisk:(UIImage*)image andToProduct:(ProductSelected*)productSel;
+ (void)deleteImageAtPath:(NSString*)path;

@end
