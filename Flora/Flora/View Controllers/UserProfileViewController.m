//
//  UserProfileViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/25/22.
//

#import "UserProfileViewController.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profPic.layer.masksToBounds = false;
    self.profPic.layer.cornerRadius = self.profPic.frame.size.width/2;
    self.profPic.clipsToBounds = true;
    self.profPic.layer.borderWidth = 0.05;
    
    if(self.user[@"profilePic"]) {
        self.profPic.file = self.user[@"profilePic"];
        [self.profPic loadInBackground];
    } else {
        [self.profPic setImage:[UIImage systemImageNamed:@"person"]];
    }
    
    self.username.text = self.user.username;
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
