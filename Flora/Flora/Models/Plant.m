//
//  Plant.m
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import "Plant.h"
#import "APIManager.h"
#import "UIImage+AFNetworking.h"
#import "Elog.h"


@implementation Plant

@dynamic objectId;
@dynamic name;
@dynamic image;
@dynamic moistureUse;
@dynamic shadeLevel;
@dynamic minTemp;
@dynamic plantId;

+ (nonnull NSString *)parseClassName {
    return @"Plant";
}

+ (void) savePlant: (UIImage * _Nullable)image withName :( NSString * _Nullable)name characteristics:(NSDictionary * _Nullable)characteristics withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    Plant *newPlant = [Plant new];
    newPlant.name = name;
    newPlant.image = [self getPFFileFromImage:image];
    newPlant.moistureUse = characteristics[@"moist"];
    newPlant.shadeLevel = characteristics[@"shade"];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSNumber *tempNumber = [f numberFromString:characteristics[@"temp"]];
    newPlant.minTemp = tempNumber;
    
    [newPlant saveInBackgroundWithBlock:completion];
}

+ (void) savePlantWithDict:(NSDictionary *)dict withCompletion: (PFBooleanResultBlock _Nullable)completion{
    
    NSString *plantId = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    // save plant to database
    [[APIManager shared] getPlantCharacteristicsWithId:plantId completion:^(NSString * _Nonnull shade, NSString * _Nonnull moist, NSString * _Nonnull temp, NSError * _Nonnull error) {
        if(error) {
            Elog(@"Error getting plant characteristics: %@", error);
        } else {
            [Plant savePlantWithCharsMoistureUse:moist shadeLevel:shade minimumTemp:temp fromPlantDict:dict withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if(error) {
                    Elog(@"Error saving plant: %@", error.localizedDescription);
                }
            }];
        }
    }];
    
}

+ (instancetype) savePlantWithCharsMoistureUse:(NSString *)moist shadeLevel:(NSString *)shade minimumTemp:(NSString *)temp fromPlantDict:(NSDictionary *)dict withCompletion: (PFBooleanResultBlock _Nullable)completion{
    
    Plant *newPlant = [Plant new];
    newPlant.name = [dict[@"CommonName"] lowercaseString];
    
    NSURL *imageUrl = [[APIManager shared] getPlantImageURL:dict[@"ProfileImageFilename"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    newPlant.image = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    
    NSString *plantId = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    newPlant.plantId = plantId;
    
    newPlant.moistureUse = moist;
    newPlant.shadeLevel = shade;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSNumber *tempNumber = [f numberFromString:temp];
    newPlant.minTemp = tempNumber;
        
    [newPlant saveInBackgroundWithBlock: completion];
    
    return newPlant;
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }

    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


@end
