//
//  PostCell.m
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.postImage.file = post.image;
    [self.postImage loadInBackground];
    
    self.plantImage.file = post.plant.image;
    [self.plantImage loadInBackground];
    
    self.usernameLabel.text = post.author.username;
    self.profileImage.file = post.author[@"profilePic"];
}

@end
