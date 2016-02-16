//
//  ProductSelected+CoreDataProperties.h
//  
//
//  Created by Nikita Gil' on 13.02.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ProductSelected.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductSelected (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *product_id;
@property (nullable, nonatomic, retain) NSString *product_title;
@property (nullable, nonatomic, retain) NSString *product_description;
@property (nullable, nonatomic, retain) NSString *product_price;
@property (nullable, nonatomic, retain) NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END
