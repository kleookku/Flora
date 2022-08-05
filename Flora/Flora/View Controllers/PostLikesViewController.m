//
//  PostLikesViewController.m
//  Flora
//
//  Created by Kleo Ku on 8/5/22.
//

#import "PostLikesViewController.h"
#import "UserProfileViewController.h"
#import "APIManager.h"
#import "PostLikesCell.h"

@interface PostLikesViewController () <UITableViewDelegate, UITableViewDataSource, PostLikesCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *filteredUsers;
@property (nonatomic, strong) PFUser *userToDisplay;

@end

@implementation PostLikesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self updateUsers];
}

#pragma mark - PostLikesCellDelegate

- (void)tappedUserProfile:(PFUser *)user {
    self.userToDisplay = user;
    [self performSegueWithIdentifier:@"LikesToProfile" sender:nil];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostLikesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostLikesCell"];
    cell.delegate = self;
    PFUser *user = self.users[indexPath.row];
    cell.user = user;
    return cell;
}

#pragma mark - Networking

- (void)updateUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            [self presentViewController:[APIManager errorAlertWithTitle:@"Error getting users" withMessage:error.localizedDescription] animated:YES completion:nil];
        } else if (objects.count > 0){
            NSMutableArray *newUsers = [[NSMutableArray alloc] init];
            for(PFUser *user in objects) {
                if([self.post.userLikes containsObject:user.username]) {
                    [newUsers addObject:user];
                }
            }
            self.users = newUsers;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UserProfileViewController *userProfVC = [segue destinationViewController];
    userProfVC.user = self.userToDisplay;
    userProfVC.notMyProfile = YES;
}


@end
