//
//  BoardViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/13/22.
//

#import "BoardViewController.h"
#import "PlantCell.h"
#import "AddViewController.h"
#import "DetailViewController.h"
#import "Plant.h"
#import "UITextView_Placeholder/UITextView+Placeholder.h"

@interface BoardViewController () <UICollectionViewDataSource, PlantCellDelegate, AddViewControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *boardNameField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addPlantButton;
@property (nonatomic, strong)NSString *previousName;
@property (weak, nonatomic) IBOutlet UITextView *notesView;

@property (nonatomic, strong) Plant* plantToPresent;

@property BOOL editing;

@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.boardNameField.userInteractionEnabled = NO;
    self.boardNameField.text = self.board.name;
    
    self.collectionView.dataSource = self;
    self.cellDelegates = [[NSMutableArray alloc] init];
    self.boardNameField.borderStyle = UITextBorderStyleNone;
    
    self.editButton.layer.cornerRadius = 10;
    self.editButton.tag = 1;
    self.addPlantButton.layer.cornerRadius = 7;
    
    self.notesView.delegate = self;
    self.notesView.layer.cornerRadius = 15;
    self.notesView.layoutMargins = UIEdgeInsetsMake(2, 5, 2, 5);
    self.notesView.placeholder = @"Description";
    self.notesView.userInteractionEnabled = NO;
    [self.notesView setScrollEnabled:NO];
    

    if(self.board.notes) {
        self.notesView.text = self.board.notes;
    }
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
                cell.plant = plant;
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

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    // self.notesView.text.length
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text length] == 0) {
        if([textView.text length] != 0)
            return YES;
    }
    else if([[textView text] length] > 100)
        return NO;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.board.notes = textView.text;
    [self.board saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error updating board description: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully saved board description!");
                [self.delegate stoppedEdit];
            }
    }];
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

- (void)presentPlantWithId:(Plant *)plant {
    self.plantToPresent = plant;
    [self performSegueWithIdentifier:@"BoardPlantDetailsSegue" sender:nil];
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
        self.notesView.userInteractionEnabled = NO;
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
        self.notesView.userInteractionEnabled = YES;
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
    if([sender tag] == 1) {
        AddViewController *addViewVC = [segue destinationViewController];
        addViewVC.board = self.board;
        addViewVC.delegate = self;
    } else {
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.plant = self.plantToPresent;
        detailVC.delegate = self.delegate;
    }
}


@end
