//
//  Post.h
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import <Parse/Parse.h>
#import "Plant.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;


@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) Plant *plant;

@end

NS_ASSUME_NONNULL_END
