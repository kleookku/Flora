//
//  Plant.h
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Plant : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *moistureUse;
@property (nonatomic, strong) NSString *shadeLevel;
@property (nonatomic, strong) NSString *minTemp;

+ (void) savePlant: (UIImage * _Nullable)image withName :( NSString * _Nullable)name characteristics:(NSDictionary * _Nullable)characteristics withCompletion: (PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
