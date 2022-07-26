//
//  FollowViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import "FollowViewController.h"
#import "UserCell.h"
#import "Parse/Parse.h"
#import "Follow.h"
#import "UserSearchViewController.h"
#import "UserProfileViewController.h"

@interface FollowViewController () <UITableViewDelegate, UITableViewDataSource, UserCellDelegate, UserSearchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *followersArray;
@property (nonatomic, strong)NSArray *followingArray;

@property (weak, nonatomic) IBOutlet UIButton *addUsersButton;
@property (nonatomic, strong)PFUser *user;
@property (nonatomic, strong)PFUser *userToShow;

@end

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.user = [PFUser currentUser];
    
    [self getFollowing];
    [self getFollowers];
    
    self.addUsersButton.tag = 1;
    
}

- (IBAction)segmentChanged:(id)sender {
    [self.tableView reloadData];
}

#pragma mark - UserCellDelegate
- (void)presentAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)removeUser:(NSString *)username fromSegment:(int)segment {
    if(segment == 0){
        NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.followersArray copyItems:YES];
        [temp removeObject:username];
        self.followersArray = temp;
        [self.tableView reloadData];
    } else {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.followingArray copyItems:YES];
        [temp removeObject:username];
        self.followingArray = temp;
        [self.tableView reloadData];
    }
}

- (void)tappedUserProfile:(PFUser *)user {
    self.userToShow = user;
    [self performSegueWithIdentifier:@"FollowToProfile" sender:nil];
}

#pragma mark - UserSearchViewControllerDelegate

- (void)updateTable {
    [self getFollowing];
    [self getFollowers];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.segmentControl.selectedSegmentIndex == 0) {
        return self.followersArray.count;
    } else {
        return self.followingArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    cell.delegate = self;
    
    NSString *username = nil;
    
    if(self.segmentControl.selectedSegmentIndex == 0) {
        username = self.followersArray[indexPath.row];
        cell.isFollower = YES;
        [cell.followButton setTitle:@"Remove" forState:UIControlStateNormal];
    } else {
        username = self.followingArray[indexPath.row];
        cell.isFollower = NO;
        [cell.followButton setTitle:@"Following" forState:UIControlStateNormal];
        
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error getting user %@", error.localizedDescription);
        } else if(objects.count >0) {
            PFUser *user = (PFUser *)objects[0];
            cell.user = user;
            
            if(user[@"profilePic"]) {
                cell.profPic.file = user[@"profilePic"];
                [cell.profPic loadInBackground];
            } else {
                [cell.profPic setImage:[UIImage systemImageNamed:@"person"]];
            }
            
            cell.username.text = user.username;
            
            NSArray *userBoards = user[@"boards"];
            cell.numBoards.text = [NSString stringWithFormat:@"%li boards", userBoards.count];
        }
    }];
    return cell;
}

#pragma mark - Networking

- (void)getFollowers {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"username" equalTo:self.user.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting followers: %@", error.localizedDescription);
        } else {
            NSMutableArray *followers = [[NSMutableArray alloc] init];
            
            for(Follow *follow in objects){
                [followers addObject:follow.follower];
            }
            
            self.followersArray = followers;
            [self.tableView reloadData];
        }
    }];
}

- (void) getFollowing {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:self.user.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting following: %@", error.localizedDescription);
        } else {
            NSMutableArray *following = [[NSMutableArray alloc] init];
            
            for(Follow *follow in objects){
                [following addObject:follow.username];
            }
            
            self.followingArray = following;
            [self.tableView reloadData];
        }
    }];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([sender tag] == 1) {
         UserSearchViewController *userSearchVC = [segue destinationViewController];
         userSearchVC.delegate = self;
     } else {
         UserProfileViewController *userProfVC = [segue destinationViewController];
         userProfVC.user = self.userToShow;
     }
 }
 

@end
