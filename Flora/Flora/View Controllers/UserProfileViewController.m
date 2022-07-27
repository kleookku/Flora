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
#import "Board.h"
#import "Plant.h"
#import "BoardViewController.h"

@interface UserProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ProfileBoardCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet PFImageView *profPic;

@property (nonatomic, strong) Board *boardToView;
@property (nonatomic, strong)NSArray *boardsArray;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.separatorView.layer.cornerRadius = 5;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.profPic.layer.masksToBounds = false;
    self.profPic.layer.cornerRadius = self.profPic.frame.size.width/2;
    self.profPic.clipsToBounds = true;
    self.profPic.layer.borderWidth = 0.05;
    
    if(self.user[@"profilePic"]) {
        self.profPic.file = self.user[@"profilePic"];
        [self.profPic loadInBackground];
    } else {
        [self.profPic setImage:[UIImage systemImageNamed:@"person"]];
    }
    
    self.username.text = [NSString stringWithFormat:@"%@'s boards", self.user.username];
    
    [self updateBoards];
}

#pragma mark - ProfileBoardCellDelegate

- (void) didTapBoard:(Board *)board {
    self.boardToView = board;
    [self performSegueWithIdentifier:@"UserBoardDetails" sender:nil];
}

#pragma mark - UICollectionView

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfileBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileBoardCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    Board *board = self.boardsArray[indexPath.row];
    cell.board = board;

    return cell;
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BoardViewController *boardVC = [segue destinationViewController];
    boardVC.board = self.boardToView;
    boardVC.myBoard = NO;
}


@end
