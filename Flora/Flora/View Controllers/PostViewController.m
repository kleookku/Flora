//
//  PostViewController.m
//  Flora
//
//  Created by Kleo Ku on 8/1/22.
//

#import "PostViewController.h"
#import "DetailViewController.h"
#import "Parse/PFImageView.h"
#import "DateTools.h"
#import "APIManager.h"
#import "CommentsViewController.h"
#import "Elog.h"

#define PLANT_BUTTON 1
#define COMMENT_BUTTON 2

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *dateCreated;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet PFImageView *plantImage;
@property (weak, nonatomic) IBOutlet UIButton *plantButton;
@property (weak, nonatomic) IBOutlet UILabel *captionUsernameLabel;

@property (nonatomic, strong)CABasicAnimation *likeAnimation;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.plantButton.tag = PLANT_BUTTON;
    self.commentButton.tag = COMMENT_BUTTON;
    
    _likeAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    _likeAnimation.duration=0.15;
    _likeAnimation.autoreverses=YES;
    _likeAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    _likeAnimation.toValue=[NSNumber numberWithFloat:0.5];
    _likeAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.post fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error) {
            [APIManager errorAlertWithTitle:@"Error getting post" withMessage:error.localizedDescription];
        } else {
            self.postImage.file = self.post.image;
            [self.postImage loadInBackground];
            self.postImage.layer.cornerRadius = 40;
            
             UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likedPost:)];
            doubleTapGesture.numberOfTapsRequired = 2;
            [self.postImage addGestureRecognizer:doubleTapGesture];
            self.postImage.userInteractionEnabled = YES;
            
            self.dateCreated.text = [self.post.createdAt shortTimeAgoSinceNow];
            self.caption.text = self.post.caption;
            self.likeCount.text = [NSString stringWithFormat:@"%lu likes", self.post.userLikes.count];
            self.commentCount.text = [NSString stringWithFormat:@"%@ comments", [self.post.commentCount stringValue]];
        }        
    }];
    
    [self.post.author fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error) {
            [APIManager errorAlertWithTitle:@"Error getting post author" withMessage:error.localizedDescription];
        } else {
            self.username.text = self.post.author.username;
            self.captionUsernameLabel.text = self.post.author.username;
            
            if(self.post.author[@"profilePic"]) {
                self.profileImage.file = self.post.author[@"profilePic"];
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
        }
    }];
    
    [self.post.plant fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error) {
            [APIManager errorAlertWithTitle:@"Error getting post plant" withMessage:error.localizedDescription];
        } else {
            self.plantImage.file = self.post.plant.image;
            [self.plantImage loadInBackground];
            self.plantImage.layer.cornerRadius = 25;
            self.plantImage.layer.borderColor = [[UIColor whiteColor] CGColor];
            self.plantImage.layer.borderWidth = 1;
        }
    }];
    
    [self updateLikes];
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
    self.likeCount.text = [NSString stringWithFormat:@"%lu likes", self.post.userLikes.count];
    
    if ([self.post.userLikes containsObject:[PFUser currentUser].username]) {
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        [self.likeButton setTintColor:[UIColor redColor]];
        [self.likeButton setUserInteractionEnabled:YES];
    } else {
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        [self.likeButton setTintColor:[UIColor lightGrayColor]];
        [self.likeButton setUserInteractionEnabled:YES];
    }
}

# pragma mark - Actions

- (IBAction)didTapPlant:(id)sender {
    [self performSegueWithIdentifier:@"PostToPlant" sender:sender];
}

- (IBAction)didTapLike:(id)sender {
    [self likedPost:nil];
}

- (IBAction)didTapComment:(id)sender {
    [self performSegueWithIdentifier:@"PostToComments" sender:sender];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender tag] == 1) {
        DetailViewController *detailVC = [segue destinationViewController];
        [self.post.plant fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if(error) {
                [APIManager errorAlertWithTitle:@"Error getting post plant" withMessage:error.localizedDescription];
            } else {
                detailVC.plant = self.post.plant;
            }
        }];
    } else if ([sender tag] == 2) {
        CommentsViewController *commentsVC = [segue destinationViewController];
        commentsVC.post = self.post;
    }
}


@end
