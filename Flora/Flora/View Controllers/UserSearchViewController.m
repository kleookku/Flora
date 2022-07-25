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

@interface UserSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UserSearchCellDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *userResults;
@property (nonatomic, strong)PFUser *user;
@property (nonatomic, strong)NSArray *following;
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
    
    [self getFollowing];
}

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

- (void)viewDidDisappear:(BOOL)animated {
    [self.delegate updateTable];
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

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserSearchCell"];
    PFUser *user = self.userResults[indexPath.row];
    
    cell.delegate = self;
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

- (void)getFollowing {
    NSMutableArray *getFollowing = [[NSMutableArray alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:currentUser.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting follow: %@", error.localizedDescription);
        } else if (objects.count > 0){
            for(Follow *follow in objects) {
                [getFollowing addObject:follow.username];
            }
            self.following = getFollowing;
            [self.tableView reloadData];
        }
    }];
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
