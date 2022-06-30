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

- (void)charSearch:(void(^)(NSArray *results, NSError *error))completion;

- (void)plantProfile:(NSString *)symbol completion:(void (^)(NSDictionary *dict, NSError *error))completion;

- (void)plantChars:(NSString *)plantId completion:(void (^)(NSArray *chars, NSError *error))completion;


@end

NS_ASSUME_NONNULL_END
