//
//  APIManager.h
//  Flora
//
//  Created by Kleo Ku on 6/30/22.
//

#import <BDBOAuth1SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : BDBOAuth1SessionManager

// you should add a function for each API request you want to support

+ (instancetype)shared;

- (void)characteristicSearch:(NSDictionary *)selections completion:(void(^)(NSArray *results, NSError *error))completion;

- (void)getPlantCharacteristics:(NSString *)plantId completion:(void (^)(NSDictionary *characteristics, NSError *error))completion;



@end

NS_ASSUME_NONNULL_END
