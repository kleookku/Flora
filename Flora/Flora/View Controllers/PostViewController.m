//
//  PostViewController.m
//  Flora
//
//  Created by Kleo Ku on 8/1/22.
//

#import "PostViewController.h"
#import "DetailViewController.h"
#import "Parse/PFImageView.h"
#import "DateTools/DateTools.h"

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
@property (weak, nonatomic) IBOutlet UILabel *captionUsernameLabel;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.post fetchIfNeeded];
    [self.post.author fetchIfNeeded];
    [self.post.plant fetchIfNeeded];
    // Do any additional setup after loading the view.
    self.postImage.file = self.post.image;
    [self.postImage loadInBackground];
    self.postImage.layer.cornerRadius = 40;
    
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
    
    
    self.username.text = self.post.author.username;
    self.captionUsernameLabel.text = self.post.author.username;
    self.dateCreated.text = [self.post.createdAt shortTimeAgoSinceNow];
    self.caption.text = self.post.caption;
    self.likeCount.text = [NSString stringWithFormat:@"%@ likes", [self.post.likeCount stringValue]];
    self.commentCount.text = [NSString stringWithFormat:@"%@ comments", [self.post.commentCount stringValue]];
    
    self.plantImage.file = self.post.plant.image;
    [self.plantImage loadInBackground];
    self.plantImage.layer.cornerRadius = 25;
    self.plantImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.plantImage.layer.borderWidth = 1;
}

- (IBAction)didTapPlant:(id)sender {
    [self performSegueWithIdentifier:@"PostToPlant" sender:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detailVC = [segue destinationViewController];
    [self.post.plant fetchIfNeeded];
    detailVC.plant = self.post.plant;
}


@end
