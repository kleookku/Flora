//
//  Plant.m
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import "Plant.h"
#import "APIManager.h"
#import "UIImage+AFNetworking.h"

@implementation Plant

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
    newPlant.minTemp = characteristics[@"temp"];
    
    [newPlant saveInBackgroundWithBlock:completion];
}

+ (void) savePlantWithDict:(NSDictionary *)dict withCompletion: (PFBooleanResultBlock _Nullable)completion{
    
    NSString *plantId = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    // save plant to database
    [[APIManager shared] getPlantCharacteristicsWithId:plantId completion:^(NSString * _Nonnull shade, NSString * _Nonnull moist, NSString * _Nonnull temp, NSError * _Nonnull error) {
        if(error) {
            NSLog(@"Error getting plant characteristics: %@", error);
        } else {
            [Plant savePlantWithCharsMoistureUse:moist shadeLevel:shade minimumTemp:temp fromPlantDict:dict withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                            if(error) {
                                NSLog(@"Error saving plant: %@", error.localizedDescription);
                            } else {
                                NSLog(@"Successfully saved plant!");

                            }
            }];
        }
    }];
    
}

+ (instancetype) savePlantWithCharsMoistureUse:(NSString *)moist shadeLevel:(NSString *)shade minimumTemp:(NSString *)temp fromPlantDict:(NSDictionary *)dict withCompletion: (PFBooleanResultBlock _Nullable)completion{
    
    Plant *newPlant = [Plant new];
    newPlant.name = dict[@"CommonName"];
    
    NSURL *imageUrl = [[APIManager shared] getPlantImageURL:dict[@"ProfileImageFilename"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    newPlant.image = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    
    NSString *plantId = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    newPlant.plantId = plantId;
    
    newPlant.moistureUse = moist;
    newPlant.shadeLevel = shade;
    newPlant.minTemp = temp;
        
    NSLog(@"plant %@", newPlant);
    
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
