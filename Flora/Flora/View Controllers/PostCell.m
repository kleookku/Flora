//
//  PostCell.m
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import "PostCell.h"
#import "DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.plantImage.layer.borderColor = [[UIColor blackColor] CGColor];
    self.plantImage.layer.borderWidth = 3;
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [recognizer setMinimumPressDuration:1.0];
    [self.plantImage setUserInteractionEnabled:YES];
    [self.plantImage addGestureRecognizer:recognizer];
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
    self.plantImage.layer.cornerRadius = 20;
    self.plantImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.plantImage.layer.borderWidth = 3;
    
    self.usernameLabel.text = post.author.username;
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
    
    self.likeCountLabel.text = [self.post.likeCount stringValue];
    self.commentCountLabel.text = [self.post.commentCount stringValue];
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.plantImage setFrame:CGRectMake(30, 30, 250, 250)];
    } if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.plantImage setFrame:CGRectMake(30, 30, 100, 100)];
    }
}
    
    @end
