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
    if(![currentUser[@"following"] containsObject:self.user.username]) {
        self.followButton.backgroundColor = [UIColor systemGray6Color];
        self.followButton.tintColor = [UIColor darkGrayColor];
        [self.followButton setTitle:@"Following" forState:UIControlStateNormal];
        
    } else {
        self.followButton.backgroundColor = [UIColor systemBlueColor];
        self.followButton.tintColor = [UIColor whiteColor];
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    }
    [APIManager userFollowedOrUnfollowed:self.user];
}

@end
