//
//  FollowViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import "FollowViewController.h"
#import "UserCell.h"
#import "Parse/Parse.h"

@interface FollowViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *followersArray;
@property (nonatomic, strong)NSArray *followingArray;

@property (nonatomic, strong)PFUser *user;

@end

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.user = [PFUser currentUser];
    
    self.followingArray = self.user[@"following"];
    self.followersArray = self.user[@"followers"];
}

- (IBAction)segmentChanged:(id)sender {
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.segmentControl.selectedSegmentIndex == 0) {
        return self.followersArray.count;
    } else {
        return self.followingArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
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
        } else {
            PFUser *user = (PFUser *)objects[0];
            cell.user = user;
            
            cell.profPic.file = user[@"profilePic"];
            [cell.profPic loadInBackground];
            
            cell.username.text = user.username;
            
            NSArray *userBoards = user[@"boards"];
            cell.numBoards.text = [NSString stringWithFormat:@"%li boards", userBoards.count];
        }
    }];
    
    return cell;
}

- (void)getUserWithName:(NSString *)username {
    
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
