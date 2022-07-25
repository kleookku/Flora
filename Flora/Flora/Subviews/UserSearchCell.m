//
//  UserSearchCell.m
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import "UserSearchCell.h"
#import "Parse/Parse.h"
#import "APIManager.h"

@implementation UserSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.profPic.layer.masksToBounds = false;
    self.profPic.layer.cornerRadius = self.profPic.frame.size.width/2;
    self.profPic.clipsToBounds = true;
    self.profPic.layer.borderWidth = 0.05;
    
    self.followButton.layer.cornerRadius = 10;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onTapFollow:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:currentUser.username];
    [query whereKey:@"username" equalTo:self.user.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting follow: %@", error.localizedDescription);
        } else if (objects.count > 0){
            self.followButton.backgroundColor = [UIColor systemBlueColor];
            self.followButton.tintColor = [UIColor whiteColor];
            [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
            [APIManager unfollowUser:self.user];
            [self.delegate unfollow:self.user.username];
        } else {
            self.followButton.backgroundColor = [UIColor systemGray6Color];
            self.followButton.tintColor = [UIColor darkGrayColor];
            [self.followButton setTitle:@"Following" forState:UIControlStateNormal];
            [APIManager followUser:self.user];
            [self.delegate follow:self.user.username];
        }
    }];
}

@end
