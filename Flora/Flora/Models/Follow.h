//
//  Follow.h
//  Flora
//
//  Created by Kleo Ku on 7/25/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Follow : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *follower;
@property (nonatomic, strong) NSString *objectId;

+ (void) saveFollow: (NSString * _Nullable)username withFollower: (NSString * _Nullable)follower withCompletion: (PFBooleanResultBlock _Nullable)completion;


@end

NS_ASSUME_NONNULL_END
