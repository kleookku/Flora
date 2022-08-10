//
//  FeedViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import "FeedViewController.h"
#import "PostCell.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "Follow.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *postsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updatePosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self updatePosts];
}

# pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
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
            NSLog(@"Error getting following: %@", error.localizedDescription);
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
            NSLog(@"%@", error.localizedDescription);
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
