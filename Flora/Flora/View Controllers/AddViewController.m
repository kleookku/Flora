//
//  AddViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/15/22.
//

#import "AddViewController.h"
#import "AddPlantCell.h"
#import "Plant.h"
#import "Parse/PFImageView.h"

@interface AddViewController () <UICollectionViewDataSource, AddPlantCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *plantsToAdd;
@property (nonatomic, strong)NSArray *likesArray;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.cancelButton.layer.cornerRadius = 15;
    self.saveButton.layer.cornerRadius = 15;
    self.likesArray = [PFUser currentUser][@"likes"];
    self.plantsToAdd = [[NSMutableArray alloc] init];
}

#pragma mark - Actions
- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSave:(id)sender {
    NSMutableArray *plants = [[NSMutableArray alloc] initWithArray:self.board[@"plantsArray"] copyItems:YES];
    [plants addObjectsFromArray:self.plantsToAdd];
    self.board[@"plantsArray"] = plants;
    
    [self.board saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error saving plants to board: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully saved plants to board!");
                [self dismissViewControllerAnimated:YES completion:nil];
            }
    }];
    
    [self.delegate updateBoard];
}

#pragma mark - AddPlantCellDelegate

- (void)addedPlant:(NSString *)plantId{
    if([self.board[@"plantsArray"] containsObject:plantId]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Already exists in your board" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];

        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self.plantsToAdd addObject:plantId];

    }
}

- (void)unaddedPlant:(NSString *)plantId {
    [self.plantsToAdd removeObject:plantId];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.likesArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddPlantCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddPlantCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.plantImage.layer.cornerRadius = 20;
    cell.addButton.contentMode = UIViewContentModeScaleAspectFill;
    cell.addButton.layer.masksToBounds = false;
    cell.addButton.layer.cornerRadius = cell.addButton.frame.size.width/2;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
    [query whereKey:@"plantId" equalTo:self.likesArray[indexPath.row]];
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
        if(results) {
            if(results.count > 0) {
                Plant *plant = (Plant*)results[0];
                cell.plantId = plant.plantId;
                cell.plantImage.file = plant.image;
                [cell.plantImage loadInBackground];
                cell.plantName.text = plant.name;
            }
        } else {
            NSLog(@"Error getting liked plants: %@", error.localizedDescription);
        }
    }];
    return cell;
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
