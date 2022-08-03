//
//  UserSearchViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import "UserSearchViewController.h"
#import "Parse/Parse.h"
#import "UserSearchCell.h"
#import "Follow.h"
#import "UserProfileViewController.h"

@interface UserSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UserSearchCellDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *userResults;
@property (nonatomic, strong)PFUser *user;
@property (nonatomic, strong)NSArray *following;
@property (nonatomic, strong)PFUser *userToShow;
@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.user = [PFUser currentUser];

    // Do any additional setup after loading the view.
    
    [self updateFollowing];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.delegate updateTable];
}

# pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(![searchText isEqualToString:@""]) {
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        NSString *lowercaseText = [searchText lowercaseString];
        [query whereKey:@"username" containsString:lowercaseText];
        [query whereKey:@"username" notEqualTo:[PFUser currentUser].username];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error getting search results: %@", error.localizedDescription);
            } else {
                NSMutableArray *results = [[NSMutableArray alloc] init];
                for(PFUser *user in objects){
                    [results addObject:user];
                }
                self.userResults = results;
                [self.tableView reloadData];
            }
        }];
    } else {
        self.userResults = @[];
        [self.tableView reloadData];
    }
}

#pragma mark - UserSearchCellDelegate

- (void)unfollow:(NSString *)username {
    NSMutableArray *newFollowing = [[NSMutableArray alloc] initWithArray:self.following copyItems:YES];
    [newFollowing removeObject:username];
    self.following = newFollowing;
    [self.tableView reloadData];
}

- (void)follow:(NSString *)username {
    NSMutableArray *newFollowing = [[NSMutableArray alloc] initWithArray:self.following copyItems:YES];
    [newFollowing addObject:username];
    self.following = newFollowing;
    [self.tableView reloadData];
}

- (void)tappedUserProfile:(PFUser *)user {
    self.userToShow = user;
    [self performSegueWithIdentifier:@"SearchToProfile" sender:nil];
}

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserSearchCell"];
    cell.delegate = self;

    PFUser *user = self.userResults[indexPath.row];
    cell.user = user;
    
    if([self.following containsObject:user.username]) {
        cell.followButton.backgroundColor = [UIColor systemGray6Color];
        cell.followButton.tintColor = [UIColor darkGrayColor];
        [cell.followButton setTitle:@"Following" forState:UIControlStateNormal];
    } else {
        cell.followButton.backgroundColor = [UIColor systemBlueColor];
        cell.followButton.tintColor = [UIColor whiteColor];
        [cell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    }

    return cell;
}

- (void)updateFollowing {
    NSMutableArray *newFollowing = [[NSMutableArray alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:currentUser.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting follow: %@", error.localizedDescription);
        } else if (objects.count > 0){
            for(Follow *follow in objects) {
                [newFollowing addObject:follow.username];
            }
            self.following = newFollowing;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UserProfileViewController *userProfVC = [segue destinationViewController];
    userProfVC.user = self.userToShow;
}


@end
