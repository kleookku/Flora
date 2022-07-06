//
//  Plant.m
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import "Plant.h"

@implementation Plant

@dynamic name;
@dynamic image;
@dynamic moistureUse;
@dynamic shadeLevel;
@dynamic minTemp;

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
    
    [newPlant saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if imag eis not nil
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
