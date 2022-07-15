//
//  LikesViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/11/22.
//

#import "LikesViewController.h"
#import "Parse/Parse.h"
#import "LikesCell.h"
#import "UIImageView+AFNetworking.h"
#import "Plant.h"
#import "BoardCell.h"
#import "Board.h"
#import "BoardViewController.h"
#import "DetailViewController.h"

@interface LikesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BoardCellDelegate, LikesCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *boardsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *likedCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addBoardButton;

@property BOOL editing;

@property (nonatomic, strong)PFUser *user;
@property (nonatomic, strong)NSArray *likes;
@property (nonatomic, strong)NSArray *boards;

@property (nonatomic, strong)UIAlertController *createBoardAlert;
@property (nonatomic, strong)Board *boardToView;
@property (nonatomic, strong)Plant *plantToView;
@property BOOL clickedPlant;

@property (nonatomic, strong) UIRefreshControl *likesRefreshControl;
@property (nonatomic, strong) UIRefreshControl *boardsRefreshControl;


@end

@implementation LikesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [PFUser currentUser];
    
    NSArray *userLikes = self.user[@"likes"];
    self.likes = [[userLikes reverseObjectEnumerator] allObjects];
    self.boards = self.user[@"boards"];
    
    self.likedCollectionView.dataSource = self;
    self.boardsCollectionView.dataSource = self;
    
    self.likedCollectionView.tag = 1;
    self.boardsCollectionView.tag = 2;
    
    self.likesRefreshControl = [[UIRefreshControl alloc] init];
    [self.likesRefreshControl addTarget:self action:@selector(updateLikes) forControlEvents:UIControlEventValueChanged];
    [self.likedCollectionView insertSubview:self.likesRefreshControl atIndex:0];\
    [self.likesRefreshControl setHidden:NO];
    
    self.boardsRefreshControl = [[UIRefreshControl alloc] init];
    [self.boardsRefreshControl addTarget:self action:@selector(updateBoards) forControlEvents:UIControlEventValueChanged];
    [self.boardsCollectionView insertSubview:self.boardsRefreshControl atIndex:0];
    [self.boardsRefreshControl setHidden:NO];
        
    self.boardToView = nil;
    self.plantToView = nil;
    
    [self setupCreateBoardAlert];
    
    self.editButton.layer.cornerRadius = 10;
    self.addBoardButton.layer.cornerRadius = 10;
    self.editing = NO;
    
    self.delegates = [[NSMutableArray alloc] init];
    
    [self.likedCollectionView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLikes];
}

- (void) setupCreateBoardAlert {
    self.createBoardAlert = [UIAlertController alertControllerWithTitle:@"Create a Board" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self.createBoardAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"name";
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveBoardWithName:[[self.createBoardAlert textFields][0] text]];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancelled");
    }];
    
    [self.createBoardAlert addAction:confirmAction];
    [self.createBoardAlert addAction:cancelAction];
}

#pragma mark - Refreshing

- (void)updateLikes {
    self.likes = [[self.user[@"likes"] reverseObjectEnumerator] allObjects];
    [self.likedCollectionView reloadData];
    [self.likesRefreshControl endRefreshing];
}

- (void)updateBoards {
    self.boards = self.user[@"boards"];
    [self.boardsCollectionView reloadData];
    [self.boardsRefreshControl endRefreshing];
}

#pragma mark - Actions

- (IBAction)didTapAddBoard:(id)sender {
    [self presentViewController:self.createBoardAlert animated:YES completion:nil];
}
- (IBAction)didTapEdit:(id)sender {
    if(self.editing){
        [self.editButton setTitle:@"edit" forState:UIControlStateNormal];
        self.editing = NO;
        for(id<LikesViewControllerDelegate> delegate in self.delegates)
            [delegate stoppedEdit];
    } else {
        [self.editButton setTitle:@"done" forState:UIControlStateNormal];
        self.editing = YES;
        for(id<LikesViewControllerDelegate> delegate in self.delegates)
            [delegate tappedEdit];
    }
}

#pragma mark - BoardCellDelegate

- (void)didTapViewBoard:(Board *)board {
    self.boardToView = board;
    self.clickedPlant = NO;
    [self performSegueWithIdentifier:@"ViewBoardSegue" sender:nil];
}

- (void)deleteBoard:(NSString *)boardName {
    NSMutableArray *boardsArray = [[NSMutableArray alloc] initWithArray:self.user[@"boards"] copyItems:YES];
    [boardsArray removeObject:boardName];
    self.user[@"boards"] = boardsArray;
    self.boards = boardsArray;
    [self.boardsCollectionView reloadData];
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error)
                NSLog(@"Error deleting board from user's boards: %@", error.localizedDescription);
            else
                NSLog(@"Successfuly deleted board from user's boards!");
    }];
}

- (void)confirmBoardDelete:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - LikesCellDelegate

- (void)didTapPlant:(Plant *)plant {
    self.plantToView = plant;
    self.clickedPlant = YES;
    [self performSegueWithIdentifier:@"ViewPlantSegue" sender:nil];
}

- (void)deletePlantFromLikes:(NSString *)plantId {
    NSMutableArray *likesArray = [[NSMutableArray alloc] initWithArray:self.user[@"likes"] copyItems:YES];
    [likesArray removeObject:plantId];
    self.user[@"likes"] = likesArray;
    self.likes = [[likesArray reverseObjectEnumerator] allObjects];

    [self.likedCollectionView reloadData];
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error)
                NSLog(@"Error deleting plant from user's likes: %@", error.localizedDescription);
            else
                NSLog(@"Successfuly deleted plant from user's likes!");
    }];
}

- (void)confirmLikeDelete:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - CollectionViewDataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        LikesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikesCell" forIndexPath:indexPath];
        cell.plantImage.layer.cornerRadius = 20;
        cell.delegate = self;
        PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
        [query whereKey:@"plantId" equalTo:self.likes[indexPath.row]];
        query.limit = 1;

        [self.delegates addObject:cell];

        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
            if(results) {
                if(results.count > 0) {
                    Plant *plant = (Plant *)results[0];
                    cell.plant = plant;
                    cell.plantImage.file = plant.image;
                    [cell.plantImage loadInBackground];
                    cell.plantName.text = plant.name;
                }
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        
        return cell;
    } else {
        BoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BoardCell" forIndexPath:indexPath];
        cell.coverImage.layer.cornerRadius = 20;
        cell.delegate = self;
        PFQuery *query = [PFQuery queryWithClassName:@"Board"];
        [query whereKey:@"name" equalTo:self.boards[indexPath.row]];
        [query whereKey:@"user" equalTo:self.user.username];
        query.limit = 1;
        
        [self.delegates addObject:cell];

        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
            if(results) {
                if (results.count > 0) {
                    Board *board = (Board *)results[0];
                    cell.board = board;
                    cell.boardName.text = board.name;
                    cell.numPlants.text = [[NSString stringWithFormat:@"%li",  board.plantsArray.count] stringByAppendingString:@" plants"];
                    
                    if(board.plantsArray.count > 0) {
                        [self setBoardCoverImage:board.plantsArray[0] forCell:cell];

                    }
                    
                }
            }
        }];
        return cell;
    }
}

- (void) setBoardCoverImage:(NSString *)plantId forCell:(BoardCell *)cell {
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
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1) {
        return self.likes.count;

    } else {
        return self.boards.count;
    }
}

#pragma mark - Networking

- (void)saveBoardWithName:(NSString*)boardName {
    
    // save board PFObject to database
    [Board saveBoard:boardName withPlants:@[] forUser:[PFUser currentUser].username withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error saving board: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully saved board!");
        }
    }];
    
    // save plant to user's likes
    PFUser *user = [PFUser currentUser];
    NSMutableArray *boardsArray = [[NSMutableArray alloc] initWithArray: user[@"boards"] copyItems:YES];
    [boardsArray addObject:boardName];

    user[@"boards"] = boardsArray;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Saved!");
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {\
    if (self.clickedPlant ){
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.plant = self.plantToView;

    } else {
        BoardViewController *boardVC = [segue destinationViewController];
        boardVC.board = self.boardToView;
    }
}

@end
