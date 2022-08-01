//
//  PostGridCell.m
//  Flora
//
//  Created by Kleo Ku on 8/1/22.
//

#import "PostGridCell.h"

@implementation PostGridCell

- (void)setPost:(Post *)post {
    _post = post;
    self.postImage.file = post.image;
    [self.postImage loadInBackground];
    self.postImage.layer.cornerRadius = 20;
}

- (IBAction)tappedPost:(id)sender {
    [self.delegate didTapPost:self.post];
}
@end
