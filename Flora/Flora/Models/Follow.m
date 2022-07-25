//
//  Follow.m
//  Flora
//
//  Created by Kleo Ku on 7/25/22.
//

#import "Follow.h"

@implementation Follow

@dynamic username;
@dynamic follower;

+ (nonnull NSString *) parseClassName {
    return @"Follow";
}

+ (void) saveFollow: (NSString * _Nullable)username withFollower: (NSString * _Nullable)follower withCompletion: (PFBooleanResultBlock _Nullable)completion {
    Follow *newFollow = [Follow new];
    
    newFollow.username = username;
    newFollow.follower = follower;
    
    [newFollow saveInBackgroundWithBlock:completion];
}


@end
