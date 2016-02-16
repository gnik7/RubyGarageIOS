//
//  ImageSaver.m
//  RubyGarageIOS
//
//  Created by Nikita Gil' on 15.02.16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "ImageSaver.h"
#import "ProductSelected.h"

@implementation ImageSaver


+ (BOOL)saveImageToDisk:(UIImage*)image andToProduct:(ProductSelected*)productSel {
    NSData *imgData   = UIImageJPEGRepresentation(image, 1.0);
    NSString *name    = [[NSUUID UUID] UUIDString];
    NSString *path	  = [NSString stringWithFormat:@"Documents/%@.jpg", name];
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    if ([imgData writeToFile:jpgPath atomically:YES]) {
        productSel.imageUrl = path;
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"There was an error saving your photo. Try again."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        return NO;
    }
    return YES;
}

+ (void)deleteImageAtPath:(NSString *)path {
    NSError *error;
    NSString *imgToRemove = [NSHomeDirectory() stringByAppendingPathComponent:path];
    [[NSFileManager defaultManager] removeItemAtPath:imgToRemove error:&error];
}



@end
