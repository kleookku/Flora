//
//  Comment.m
//  Flora
//
//  Created by Kleo Ku on 8/3/22.
//

#import "Comment.h"
#import "Post.h"

@implementation Comment

@dynamic text;
@dynamic author;
@dynamic post;
@dynamic createdAt;
@dynamic likes;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

+ (void)saveComment:(NSString *)text byUser:(PFUser *)author onPost:(Post *)post withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Comment *newComment = [Comment new];
    newComment.text = text;
    newComment.author = author;
    newComment.post = post;
    newComment.likes = @[];
    
    [newComment saveInBackgroundWithBlock:completion];
}

@end
