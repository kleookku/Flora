//
//  FeedViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import "FeedViewController.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"
#import "UserProfileViewController.h"
#import "PostCell.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "Follow.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, PostCellDelegate, ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *composeButton;

@property (nonatomic, strong) NSArray *postsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong)Plant *plantSegue;
@property (nonatomic, strong)PFUser *userSegue;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.composeButton.tag = 1;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updatePosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self updatePosts];
}

#pragma mark - ComposeViewControllerDelegaet

- (void)didPost {
    [self updatePosts];
    [self.tableView reloadData];
}

#pragma mark - PostCellDelegate

- (void) plantPressed:(Plant *)plant {
    self.plantSegue = plant;
    self.userSegue = nil;
    [self performSegueWithIdentifier:@"FeedToPlant" sender:nil];
}

- (void)profilePressed:(PFUser *)user {
    self.userSegue = user;
    self.plantSegue = nil;
    [self performSegueWithIdentifier:@"FeedToProfile" sender:nil];
}


# pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.delegate = self;
    Post *post = self.postsArray[indexPath.row];
    cell.post = post;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

#pragma mark - Networking

- (void)updatePosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:[PFUser currentUser].username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            [self presentViewController:[APIManager errorAlertWithTitle:@"Error getting followed users" withMessage:error.localizedDescription] animated:YES completion:nil];
        } else {
            NSMutableArray *following = [[NSMutableArray alloc] init];
            
            for(Follow *follow in objects){
                [following addObject:follow.username];
            }
            
            [following addObject:[PFUser currentUser].username];
            
            [self queryPosts:following];
        }
    }];

}

- (void) queryPosts:(NSArray *)following {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"likeCount"];
    [query includeKey:@"plant"];
    
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts) {
            NSMutableArray *followingPosts = [[NSMutableArray alloc] init];
            for(Post *p in posts){
                if([following containsObject:p.author.username]) {
                    [followingPosts addObject:p];
                }
            }
            self.postsArray = followingPosts;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            [self presentViewController:[APIManager errorAlertWithTitle:@"Error getting posts" withMessage:error.localizedDescription] animated:YES completion:nil];
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender tag] == 1){
        ComposeViewController *composeVC = [segue destinationViewController];
        composeVC.delegate = self;
    } else if (_plantSegue){
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.plant = _plantSegue;
    } else if (_userSegue) {
        UserProfileViewController *userProfileVC = [segue destinationViewController];
        userProfileVC.user = _userSegue;
        userProfileVC.notMyProfile = YES;
    }
}

@end
