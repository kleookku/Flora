//
//  UserSearchViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import "UserSearchViewController.h"
#import "Parse/Parse.h"
#import "UserSearchCell.h"

@interface UserSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *userResults;
@property (nonatomic, strong)PFUser *user;
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

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserSearchCell"];
    PFUser *user = self.userResults[indexPath.row];
    
    cell.user = user;
    
    cell.profPic.file = user[@"profilePic"];
    [cell.profPic loadInBackground];
    
    cell.username.text = user.username;
    
    NSArray *userBoards = user[@"boards"];
    cell.numBoards.text = [NSString stringWithFormat:@"%li boards", userBoards.count];
    
    if([self.user[@"following"] containsObject:user.username]) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
