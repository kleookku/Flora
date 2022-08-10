//
//  PostLikesCell.m
//  Flora
//
//  Created by Kleo Ku on 8/5/22.
//

#import "PostLikesCell.h"
#import "Parse/Parse.h"

@implementation PostLikesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.profileImage.layer.masksToBounds = false;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = true;
    self.profileImage.layer.borderWidth = 0.05;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUser:(PFUser *)user {
    _user = user;
    PFUser *currentUser = user;
    
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if([self.user isEqual:currentUser]) {
            if(user[@"profilePic"]) {
                self.profileImage.file = user[@"profilePic"];
                [self.profileImage loadInBackground];
            } else {
                [self.profileImage setImage:[UIImage systemImageNamed:@"person"]];
            }
            
            self.username.text = user.username;
            
            NSArray *userBoards = user[@"boards"];
            self.numBoards.text = [NSString stringWithFormat:@"%li boards", userBoards.count];
        }
    }];
}

#pragma mark - Actions

- (IBAction)didTapProfile:(id)sender {
    [self.delegate tappedUserProfile:self.user];
}

@end
