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
@property (weak, nonatomic) IBOutlet UILabel *bio;
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
    
    [self getBoards];
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
    cell.boardName.text = board.name;
    cell.numPlants.text = [[NSString stringWithFormat:@"%li",  board.plantsArray.count] stringByAppendingString:@" plants"];

    [self setBoardCoverImage:board.plantsArray[0] forCell:cell];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.boardsArray.count;
}

- (void) setBoardCoverImage:(NSString *)plantId forCell:(ProfileBoardCell *)cell {
    cell.coverImage.layer.cornerRadius = 20;
    if(cell.board.coverImage) {
        cell.coverImage.file = cell.board.coverImage;
        [cell.coverImage loadInBackground];
    } else if(cell.board.plantsArray.count > 0){
        PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
        [query whereKey:@"plantId" equalTo:plantId];
        query.limit = 1;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
            if(results) {
                if(results.count > 0) {
                    Plant *plant = (Plant *)results[0];
                    cell.coverImage.file = plant.image;
                    [cell.coverImage loadInBackground];
                } else {
                    NSLog(@"Error getting board cover image: %@", error.localizedDescription);
                }
            }
        }];
    } else {
        [cell.coverImage setImage:[UIImage systemImageNamed:@"plus"]];
    }
}

#pragma mark - Parse

- (void) getBoards {
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
