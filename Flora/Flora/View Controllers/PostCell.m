//
//  PostCell.m
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import "PostCell.h"
#import "DateTools.h"

#define MULTIPLIER 4

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];    
    self.plantImage.layer.borderColor = [[UIColor blackColor] CGColor];
    self.plantImage.layer.borderWidth = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.postImage.file = post.image;
    [self.postImage loadInBackground];
    self.postImage.layer.cornerRadius = 40;
    
    self.plantImage.file = post.plant.image;
    [self.plantImage loadInBackground];
    self.plantImage.layer.cornerRadius = 25;
    self.plantImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.plantImage.layer.borderWidth = 1;
    
    self.usernameLabel.text = post.author.username;
    self.captionUsernameLabel.text = post.author.username;
    if(post.author[@"profilePic"]) {
        self.profileImage.file = post.author[@"profilePic"];
        [self.profileImage loadInBackground];
    } else {
        [self.profileImage setImage:[UIImage systemImageNamed:@"person"]];
        [self.profileImage setBackgroundColor:[UIColor systemGray5Color]];
        [self.profileImage setTintColor:[UIColor systemGray4Color]];
    }
    self.profileImage.layer.masksToBounds = false;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = true;
    self.profileImage.layer.borderWidth = 0.05;
    
    self.dateLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
    self.captionLabel.text = self.post.caption;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@ likes", [self.post.likeCount stringValue]];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@ comments", [self.post.commentCount stringValue]];
    
}

#pragma mark - Actions

- (IBAction)didTapPlant:(id)sender {
    [self.delegate plantPressed:self.post.plant];
}

- (IBAction)didTapProfile:(id)sender {
    [self.delegate profilePressed:self.post.author];
}

    @end
