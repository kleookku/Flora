//
//  Comment.h
//  Flora
//
//  Created by Kleo Ku on 8/3/22.
//

#import <Parse/Parse.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject <PFSubclassing>

@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)PFUser *author;
@property (nonatomic, strong)NSDate *createdAt;
@property (nonatomic, strong)Post *post;
@property (nonatomic, strong)NSArray *likes;

@end

NS_ASSUME_NONNULL_END
