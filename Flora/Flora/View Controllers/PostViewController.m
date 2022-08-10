//
//  PostViewController.m
//  Flora
//
//  Created by Kleo Ku on 8/1/22.
//

#import "PostViewController.h"
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

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.post fetchIfNeeded];
    [self.post.author fetchIfNeeded];
    // Do any additional setup after loading the view.
    self.postImage.file = self.post.image;
    [self.postImage loadInBackground];
    self.profileImage.file = self.post.author[@"profilePic"];
    [self.profileImage loadInBackground];
    self.username.text = self.post.author.username;
    self.dateCreated.text = [self.post.createdAt shortTimeAgoSinceNow];
    self.caption.text = self.post.caption;
    self.likeCount.text = [self.post.likeCount stringValue];
    self.commentCount.text = [self.post.commentCount stringValue];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
