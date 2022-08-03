//
//  APIManager.h
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import <BDBOAuth1SessionManager.h>
#import "Plant.h"


NS_ASSUME_NONNULL_BEGIN

@interface APIManager : BDBOAuth1SessionManager

// you should add a function for each API request you want to support

+ (instancetype)shared;

+ (NSData *)searchBody;

- (void)searchWithShadeLevel:(NSArray *)shade withMoistureUse:(NSArray *)moist withMinTemperature:(NSArray *)temp offsetBy:(NSUInteger)offset completion:(void(^)(NSArray *results, NSError *error))completion;

- (void)getPlantCharacteristicsWithId:(NSString *)plantId completion:(void (^)(NSString *shade, NSString *moist, NSString *temp, NSError *error))completion;

- (NSURL *)getPlantImageURL:(NSString *) filename;

+ (void)saveBoardWithName:(NSString *) boardName;

- (void)weatherValuesAtLat:(NSString *)lat atLong:(NSString *)lon withCompletion:(void(^)(int moist, int sun, int temp, NSError *error))completion;

+ (void)unfollowUser:(PFUser *) user;

+ (void)followUser:(PFUser *) user;

+ (void)removeFollower:(PFUser *) user;

+ (void)savePlantToLikes:(Plant *)plant;

+ (void)removePlantFromLikes:(Plant *)plant;

+ (void)savePlantToSeen:(Plant *)plant;

- (void)searchWithOffset:(NSUInteger)offset completion:(void(^)(NSArray *results, NSError *error))completion;


@end

NS_ASSUME_NONNULL_END
