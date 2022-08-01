//
//  UserProfileViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/25/22.
//

#import "UserProfileViewController.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "ProfileBoardCell.h"
#import "PostGridCell.h"
#import "Board.h"
#import "Plant.h"
#import "BoardViewController.h"
#import "PostViewController.h"
#import "ProfileViewController.h"

@interface UserProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ProfileBoardCellDelegate, PostGridCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet PFImageView *profPic;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic, strong) Board *boardToView;
@property (nonatomic, strong) Post *postToView;
@property (nonatomic, strong)NSArray *boardsArray;
@property (nonatomic, strong)NSArray *postsArray;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editButton.tag = 1;
    
    if(self.notMyProfile) {
        [self.editButton setHidden:YES];
    } else {
        self.user = [PFUser currentUser];
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.profPic.layer.masksToBounds = false;
    self.profPic.layer.cornerRadius = self.profPic.frame.size.width/2;
    self.profPic.clipsToBounds = true;
    self.profPic.layer.borderWidth = 0.05;
    
    self.editButton.layer.cornerRadius = 20;
    
    if(self.user[@"profilePic"]) {
        self.profPic.file = self.user[@"profilePic"];
        [self.profPic loadInBackground];
    } else {
        [self.profPic setImage:[UIImage systemImageNamed:@"person"]];
    }
    
    self.username.text = self.user.username; //[NSString stringWithFormat:@"%@'s boards", self.user.username];
    
    [self updateBoards];
    [self updatePosts];
}

#pragma mark - Actions

- (IBAction)segmentControlChanged:(id)sender {
    if(_segmentedControl.selectedSegmentIndex == 0) {
        [self.collectionView reloadData];
        [self updatePosts];
    } else {
        [self.collectionView reloadData];
        [self updateBoards];
    }
}

#pragma mark - ProfileBoardCellDelegate

- (void) didTapBoard:(Board *)board {
    self.boardToView = board;
    self.postToView = nil;
    [self performSegueWithIdentifier:@"UserBoardDetails" sender:nil];
}

#pragma mark - PostGridCellDelegate

- (void) didTapPost:(Post *)post {
    self.postToView = post;
    self.boardToView = nil;
    [self performSegueWithIdentifier:@"PostDetails" sender:nil];
}

#pragma mark - UICollectionView

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        ProfileBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileBoardCell" forIndexPath:indexPath];
        cell.delegate = self;
        
        Board *board = self.boardsArray[indexPath.row];
        cell.board = board;
        
        return cell;
    } else {
        PostGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostGridCell" forIndexPath:indexPath];
        cell.delegate = self;
        
        Post *post = self.postsArray[indexPath.row];
        cell.post = post;
        
        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.boardsArray.count;
}

#pragma mark - Parse

- (void) updateBoards {
    PFQuery *query = [PFQuery queryWithClassName:@"Board"];
    [query whereKey:@"user" equalTo:self.user.username];
    [query whereKey:@"viewable" equalTo:@(YES)];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting board: %@", error.localizedDescription);
        } else if (results.count > 0) {
            self.boardsArray = results;
            [self.collectionView reloadData];
        }
    }];
}

- (void) updatePosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.user];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting posts: %@", error.localizedDescription);
        } else {
            self.postsArray = objects;
            [self.collectionView reloadData];
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender tag] != 1) {
        if(_boardToView) {
            BoardViewController *boardVC = [segue destinationViewController];
            boardVC.board = self.boardToView;
            boardVC.myBoard = NO;
        } else if(_postToView) {
            PostViewController *postVC = [segue destinationViewController];
            postVC.post = self.postToView;
        }
    }
}


@end
