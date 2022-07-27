//
//  UserCell.m
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import "UserCell.h"
#import "APIManager.h"

@implementation UserCell

- (void) setUser:(PFUser *)user {
    _user = user;
    
    if(user[@"profilePic"]) {
        self.profPic.file = user[@"profilePic"];
        [self.profPic loadInBackground];
    } else {
        [self.profPic setImage:[UIImage systemImageNamed:@"person"]];
    }
    
    self.username.text = user.username;
    
    NSArray *userBoards = user[@"boards"];
    self.numBoards.text = [NSString stringWithFormat:@"%li boards", userBoards.count];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.profPic.layer.masksToBounds = false;
    self.profPic.layer.cornerRadius = self.profPic.frame.size.width/2;
    self.profPic.clipsToBounds = true;
    self.profPic.layer.borderWidth = 0.05;
    
    self.followButton.layer.cornerRadius = 10;
    
    self.removeAlert = [UIAlertController alertControllerWithTitle:@"Remove follower?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelRemove = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirmRemove = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [APIManager removeFollower:self.user];
        [self.delegate removeUser:self.user.username fromSegment:0];
    }];
    [self.removeAlert addAction:cancelRemove];
    [self.removeAlert addAction:confirmRemove];
    [self.removeAlert setPreferredAction:cancelRemove];
    
    
    self.unfollowAlert = [UIAlertController alertControllerWithTitle: [NSString stringWithFormat:@"Unfollow user?"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelUnfollow = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirmUnfollow = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [APIManager unfollowUser:self.user];
        [self.delegate removeUser:self.user.username fromSegment:1];
    }];
    [self.unfollowAlert addAction:cancelUnfollow];
    [self.unfollowAlert addAction:confirmUnfollow];
    [self.unfollowAlert setPreferredAction:cancelUnfollow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)tappedUserProfile:(id)sender {
    [self.delegate tappedUserProfile:self.user];
}

- (IBAction)buttonTapped:(id)sender {
    if(self.isFollower) { // remove follower
        [self.delegate presentAlert:self.removeAlert];
    } else { // unfollow user
        [self.delegate presentAlert:self.unfollowAlert];
    }
}


@end
