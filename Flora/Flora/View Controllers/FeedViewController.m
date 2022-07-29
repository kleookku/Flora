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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self getPosts];
}

# pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.postsArray[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.postsArray.count;
}

#pragma mark - Networking

- (void)getPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"likeCount"];
    
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts) {
            // do something with the array of object returned by the call
            self.postsArray = posts;
            // NSLog(@"%@", posts);
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            NSLog(@"posts: %@", posts);

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
