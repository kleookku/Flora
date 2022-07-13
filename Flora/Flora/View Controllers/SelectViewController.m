//
//  SelectViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import "SelectViewController.h"
#import "Parse/Parse.h"
#import "Board.h"
#import "SelectBoardCell.h"
#import "Plant.h"

@interface SelectViewController () <UICollectionViewDataSource, SelectBoardCellDelegate>

@property (nonatomic, strong)UIAlertController *createBoardAlert;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)NSString *plantIdString;
@property (nonatomic, strong)NSArray *boards;
@property (nonatomic, strong)PFUser *user;



@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCreateBoardAlert];
    
    self.plantIdString = [NSString stringWithFormat:@"%@", self.plantId];
    self.collectionView.dataSource = self;
    self.user = [PFUser currentUser];
    self.boards = self.user[@"boards"];
}

- (void)confirmAddToBoard:(UIAlertController *) confirmation {
    [self presentViewController:confirmation animated:YES completion:nil];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectBoardCell" forIndexPath:indexPath];
    cell.coverImage.layer.cornerRadius = 20;
    cell.delegate = self;
    PFQuery *query = [PFQuery queryWithClassName:@"Board"];
    [query whereKey:@"name" equalTo:self.boards[indexPath.row]];
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
        if(results) {
            if (results.count > 0) {
                Board *board = (Board *)results[0];
                cell.board = board;
                cell.plantToAdd = self.plantIdString;
                cell.boardName.text = board.name;
                
                if(board.plantsArray.count > 0) {
                    [self setBoardCoverImage:board.plantsArray[0] forCell:cell];

                }
            }
        }
    }];
    return cell;
}

- (void) setBoardCoverImage:(NSString *)plantId forCell:(SelectBoardCell *)cell {
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
    return self.boards.count;
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

- (IBAction)didTapAddBoard:(id)sender {
    NSLog(@"clicked add board");
    [self presentViewController:self.createBoardAlert animated:YES completion:nil];
}

- (void)saveBoardWithName:(NSString*)boardName {
    // save board PFObject to database
    [Board saveBoard:boardName withPlants:@[] forUser:self.user.username withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
