//
//  BoardViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/13/22.
//

#import "BoardViewController.h"
#import "PlantCell.h"
#import "AddViewController.h"
#import "Plant.h"

@interface BoardViewController () <UICollectionViewDataSource, PlantCellDelegate, AddViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *boardNameField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addPlantButton;
@property (nonatomic, strong)NSString *previousName;

@property BOOL editing;

@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.boardNameField.userInteractionEnabled = NO;
    self.boardNameField.text = self.board.name;
    
    self.collectionView.dataSource = self;
    self.cellDelegates = [[NSMutableArray alloc] init];
    self.boardNameField.borderStyle = UITextBorderStyleNone;
    
    self.editButton.layer.cornerRadius = 10;
    self.addPlantButton.layer.cornerRadius = 7;
}

#pragma mark - UICollectionViewDataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlantCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlantCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.plantImage.layer.cornerRadius = 20;
    PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
    [query whereKey:@"plantId" equalTo:self.board.plantsArray[indexPath.row]];
    query.limit = 1;
    
    [self.cellDelegates addObject:cell];

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
        if(results) {
            if(results.count > 0) {
                Plant *plant = (Plant *)results[0];
                cell.plantImage.file = plant.image;
                [cell.plantImage loadInBackground];
                cell.plantName.text = plant.name;
                cell.plantId = plant.plantId;
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.board.plantsArray.count;
}


#pragma mark - PlantCellDelegate

- (void)deletePlantWithId:(NSString *)plantId {
    NSMutableArray *plantsArray = [[NSMutableArray alloc] initWithArray:self.board[@"plantsArray"] copyItems:YES];
    [plantsArray removeObject:plantId];
    self.board[@"plantsArray"] = plantsArray;
    [self.board saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error removing plant from board %@", error.localizedDescription);
        } else {
            NSLog(@"Removed plant from board!");
        }
    }];
    
    [self.collectionView reloadData];
}

- (void)presentConfirmationAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - AddViewControllerDelegate

- (void)updateBoard {
    [self.collectionView reloadData];
}

#pragma mark - Actions

- (IBAction)didTapEdit:(id)sender {
    if(_editing) {
        self.editing = NO;
        self.boardNameField.userInteractionEnabled = NO;
        [self.boardNameField resignFirstResponder];
        [self.addPlantButton setHidden:YES];

        [self.editButton setTitle:@"edit" forState:UIControlStateNormal];
        
        self.board.name = self.boardNameField.text;
        [self.board saveInBackground];
        
        PFUser *user = [PFUser currentUser];
        NSMutableArray *boardsArray = [[NSMutableArray alloc] initWithArray:user[@"boards"] copyItems:YES];
        NSUInteger index = [boardsArray indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *name = (NSString *)obj;
            return [name isEqualToString:self.previousName];}];
        [boardsArray replaceObjectAtIndex:index withObject:self.boardNameField.text];
        user[@"boards"] = boardsArray;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error saving user's board: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully saved board for user!");
            }
        }];
        for (id<BoardViewControllerDelegate> delegate in _cellDelegates) {
            [delegate stoppedEdit];
        }
        
        [self.delegate stoppedEdit];

    } else {
        self.previousName = self.board.name;
        self.editing = YES;
        self.boardNameField.userInteractionEnabled = YES;
        [self.addPlantButton setHidden:NO];
        [self.boardNameField becomeFirstResponder];
        [self.editButton setTitle:@"done" forState:UIControlStateNormal];
        for (id<BoardViewControllerDelegate> delegate in _cellDelegates) {
            [delegate tappedEdit];
        }
    }
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddViewController *addViewVC = [segue destinationViewController];
    addViewVC.board = self.board;
    addViewVC.delegate = self;
}


@end
