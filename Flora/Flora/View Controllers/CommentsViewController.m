//
//  CommentsViewController.m
//  Flora
//
//  Created by Kleo Ku on 8/3/22.
//

#import "CommentsViewController.h"
#import "UserProfileViewController.h"
#import "CommentCell.h"
#import "APIManager.h"
#import "Parse/Parse.h"

@interface CommentsViewController () <UITableViewDelegate, UITableViewDataSource, CommentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (nonatomic, strong)NSArray *comments;
@property (nonatomic, strong)PFUser *userToDisplay;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.commentField.placeholder = @"Add a comment...";
    [self updateComments];
    self.commentField.layer.cornerRadius = 30;
    
    self.profileImage.file = [PFUser currentUser][@"profilePic"];
    [self.profileImage loadInBackground];
    self.profileImage.layer.masksToBounds = false;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = true;
    self.profileImage.layer.borderWidth = 0.05;
}

# pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.post.commentCount integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.delegate = self;
    Comment *comment = _comments[indexPath.row];
    cell.comment = comment;
    return cell;
}

#pragma mark - CommentCellDelegate

- (void)displayProfile:(PFUser *)user {
    self.userToDisplay = user;
    [self performSegueWithIdentifier:@"CommentToProfile" sender:nil];
}

# pragma mark - Networking

- (void) updateComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"post" equalTo:self.post];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            [APIManager errorAlertWithTitle:@"Error getting comments" withMessage:error.localizedDescription];
        } else {
            self.comments = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Actions

- (IBAction)didTapPost:(id)sender {
    NSString *commentText = [_commentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(![commentText isEqualToString:@""]) {
        [self.commentField setUserInteractionEnabled:NO];
        [Comment saveComment:commentText byUser:[PFUser currentUser] onPost:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            [self.commentField setUserInteractionEnabled:YES];
                    if(error) {
                        [APIManager errorAlertWithTitle:@"Error posting comment" withMessage:error.localizedDescription];
                    } else {
                        [self.view endEditing:YES];
                        [self updateComments];
                        self.commentField.text = @"";
                    }
        }];
        
        int commentCountInt = [self.post.commentCount intValue] + 1;
        self.post.commentCount = [NSNumber numberWithInt:commentCountInt];
        [self.post saveInBackground];
    }
}
- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
}


 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     UserProfileViewController *userProfVC = [segue destinationViewController];
     userProfVC.user = self.userToDisplay;
     userProfVC.notMyProfile = YES;
 }
 

@end
