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
#import "APIManager.h"

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

- (void)viewWillDisappear:(BOOL)animated {
    [self.delegate boardsSelected];
}

#pragma mark - Alert

- (void) setupCreateBoardAlert {
    self.createBoardAlert = [UIAlertController alertControllerWithTitle:@"Create a Board" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self.createBoardAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"name";
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveBoardWithName:[[self.createBoardAlert textFields][0] text]];
        self.boards = self.user[@"boards"];
        [self.collectionView reloadData];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancelled");
    }];
    
    [self.createBoardAlert addAction:confirmAction];
    [self.createBoardAlert addAction:cancelAction];
}

#pragma mark - SelectBoardCellDelegate

- (void)confirmAddToBoard:(UIAlertController *) confirmation {
    [self presentViewController:confirmation animated:YES completion:nil];
}

- (void)updateBoards{
    self.boards = self.user[@"boards"];
    [self.collectionView reloadData];
}

#pragma mark - CollectionViewDataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectBoardCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.plantToAdd = self.plantIdString;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Board"];
    [query whereKey:@"name" equalTo:self.boards[indexPath.row]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
        if (results.count > 0) {
            Board *board = (Board *)results[0];
            cell.board = board;
        }
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.boards.count;
}

#pragma mark - Actions

- (IBAction)didTapAddBoard:(id)sender {
    [self presentViewController:self.createBoardAlert animated:YES completion:nil];
}

#pragma mark - Networking

- (void)saveBoardWithName:(NSString*)boardName {
    if([self.user[@"boards"] containsObject:boardName]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Duplicate Board Name" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [APIManager saveBoardWithName:boardName];
        [self updateBoards];
    }
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
