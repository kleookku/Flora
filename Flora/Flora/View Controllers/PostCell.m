//
//  PostCell.m
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import "PostCell.h"
#import "DateTools.h"
#import "APIManager.h"

#ifdef DEBUG
#    define Elog(...) NSLog(__VA_ARGS__)
#else
#    define Elog(...) /* */
#endif

#define MULTIPLIER 4

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.plantImage.layer.borderColor = [[UIColor blackColor] CGColor];
    self.plantImage.layer.borderWidth = 3;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numLikesTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.likeCountLabel addGestureRecognizer:tapGestureRecognizer];
    self.likeCountLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likedPost:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.postImage addGestureRecognizer:doubleTapGesture];
    self.postImage.userInteractionEnabled = YES;
    
    _likeAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    _likeAnimation.duration=0.15;
    _likeAnimation.autoreverses=YES;
    _likeAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    _likeAnimation.toValue=[NSNumber numberWithFloat:0.5];
    _likeAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
        
    [post fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.postImage.file = post.image;
        [self.postImage loadInBackground];
        self.postImage.layer.cornerRadius = 40;
        self.dateLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
        self.captionLabel.text = self.post.caption;
        
        self.likeCountLabel.text = [NSString stringWithFormat:@"%@ likes", [self.post.likeCount stringValue]];
        self.commentCountLabel.text = [NSString stringWithFormat:@"%@ comments", [self.post.commentCount stringValue]];
        
        [self updateLikes];
    }];
    
    [post.plant fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                self.plantImage.file = post.plant.image;
                [self.plantImage loadInBackground];
                self.plantImage.layer.cornerRadius = 25;
                self.plantImage.layer.borderColor = [[UIColor whiteColor] CGColor];
                self.plantImage.layer.borderWidth = 1;
    }];
    
    [post.author fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
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
    }];
}

- (void) likedPost:(UITapGestureRecognizer *)gesture {
    
    if(!gesture || gesture.state == UIGestureRecognizerStateRecognized){
        [self.likeButton setUserInteractionEnabled:NO];
        PFBooleanResultBlock completion = ^(BOOL succeeded, NSError * _Nullable error) {
            [self.likeButton setUserInteractionEnabled:YES];

            if(error) {
                Elog(@"Error: %@", error.localizedDescription);
            } else {
                [self updateLikes];
                [self.likeButton.layer addAnimation:self.likeAnimation forKey:@"animateOpacity"];
            }
        };
        
        if ([self.post.userLikes containsObject:[PFUser currentUser].username]) {
            [APIManager unlikePost:self.post withCompletion:completion];
        } else {
            [APIManager likePost:self.post withCompletion:completion];
        }
    }
}

- (void) updateLikes {
    self.likeCountLabel.text = [NSString stringWithFormat:@"%lu likes", self.post.userLikes.count];

    if ([self.post.userLikes containsObject:[PFUser currentUser].username]) {
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        [self.likeButton setTintColor:[UIColor redColor]];
    } else {
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        [self.likeButton setTintColor:[UIColor lightGrayColor]];
    }
}

#pragma mark - Actions

- (void) numLikesTapped {
    [self.delegate showLikes:self.post];
}

- (IBAction)didTapPlant:(id)sender {
    [self.delegate plantPressed:self.post.plant];
}

- (IBAction)didTapProfile:(id)sender {
    [self.delegate profilePressed:self.post.author];
}

- (IBAction)didTapLike:(id)sender {
    
    [self likedPost:nil];
}

- (IBAction)didTapComments:(id)sender {
    [self.delegate showComments:self.post];
}



@end
