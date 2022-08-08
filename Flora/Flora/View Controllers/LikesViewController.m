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
#import "SelectViewController.h"
#import "APIManager.h"


@interface LikesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BoardCellDelegate, LikesCellDelegate, BoardViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DetailViewControllerDelegate, SelectViewControllerDelegate>
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
@property (nonatomic, strong)Board *boardToChange;
@property (nonatomic, strong)Plant *plantToView;
@property BOOL clickedPlant;
@property (nonatomic, strong)UIAlertController *coverImageAlert;

@property (nonatomic, strong) UIRefreshControl *boardsRefreshControl;


@end

@implementation LikesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [PFUser currentUser];
    
    NSArray *userLikes = self.user[@"likes"];
    self.likes = [[userLikes reverseObjectEnumerator] allObjects];
    self.boards = self.user[@"boards"];
    
    self.likedCollectionView.dataSource = self;
    self.boardsCollectionView.dataSource = self;
    
    self.likedCollectionView.tag = 1;
    self.boardsCollectionView.tag = 2;
    
    self.boardsRefreshControl = [[UIRefreshControl alloc] init];
    [self.boardsRefreshControl addTarget:self action:@selector(updateBoards) forControlEvents:UIControlEventValueChanged];
    [self.boardsCollectionView insertSubview:self.boardsRefreshControl atIndex:0];
    [self.boardsRefreshControl setHidden:YES];
    
    self.boardToView = nil;
    self.plantToView = nil;
    
    [self setupAlerts];
    
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

- (void) setupAlerts {
    self.createBoardAlert = [UIAlertController alertControllerWithTitle:@"Create a Board" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self.createBoardAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"name";
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveBoardWithName:[[self.createBoardAlert textFields][0] text]];
        [self updateBoards];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [self.createBoardAlert addAction:confirmAction];
    [self.createBoardAlert addAction:cancelAction];
    
    self.coverImageAlert = [UIAlertController alertControllerWithTitle:@"Change cover image" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openLibrary];
    }];
    [self.coverImageAlert addAction:cancel];
    [self.coverImageAlert addAction:photos];
}


#pragma mark - Refreshing

- (void)updateLikes {
    self.likes = [[self.user[@"likes"] reverseObjectEnumerator] allObjects];
    [self.likedCollectionView reloadData];
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

- (void)didTapBoard:(Board *)board {
    if(self.editing) {
        self.boardToChange = board;
        [self presentViewController:self.coverImageAlert animated:YES completion:nil];
    } else {
        self.boardToView = board;
        self.clickedPlant = NO;
        [self performSegueWithIdentifier:@"ViewBoardSegue" sender:nil];
    }
}

- (void)deleteBoard:(NSString *)boardName {
    NSMutableArray *boardsArray = [[NSMutableArray alloc] initWithArray:self.user[@"boards"] copyItems:YES];
    [boardsArray removeObject:boardName];
    self.user[@"boards"] = boardsArray;
    self.boards = boardsArray;
    [self.boardsCollectionView reloadData];
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            [self presentViewController:[APIManager errorAlertWithTitle:@"Error deleting board" withMessage:error.localizedDescription] animated:YES completion:nil];

        }
        
    }];
}

- (void)confirmBoardDelete:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - BoardViewControllerDelegate

- (void) tappedEdit {}

- (void) stoppedEdit {
    [self updateBoards];
    [self.boardsCollectionView reloadData];
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
        if(error) {
            [self presentViewController:[APIManager errorAlertWithTitle:@"Error removing plant from likes" withMessage:error.localizedDescription] animated:YES completion:nil];

        }
    }];
}

- (void)confirmLikeDelete:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - DetailViewControllerDelegate

- (void)likedPlant {
    [self updateLikes];
}

#pragma mark - SelectViewControllerDelegate

- (void) boardsSelected {
    [self updateBoards];
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
                    
                }
            } else {
                [self presentViewController:[APIManager errorAlertWithTitle:@"Error retrieving liked plants" withMessage:error.localizedDescription] animated:YES completion:nil];

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
            if(error) {
                [self presentViewController:[APIManager errorAlertWithTitle:@"Error retrieving boards" withMessage:error.localizedDescription] animated:YES completion:nil];
            } else if (results.count > 0) {
                Board *board = (Board *)results[0];
                cell.board = board;
            }
            
        }];
        return cell;
    }
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
    if([self.user[@"boards"] containsObject:boardName]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Duplicate Board Name" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [APIManager saveBoardWithName:boardName];
    }
}

#pragma mark - Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    UIImage *resizedImage = nil;
    if(editedImage){
        resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(300, 300)];
    } else {
        resizedImage = [self resizeImage:originalImage withSize:CGSizeMake(300, 300)];
    }
    
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"coverImage.png" data:imageData];
    self.boardToChange.coverImage = imageFile;
    [self.boardToChange saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error changing cover image" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            [self updateBoards];
            // Dismiss UIImagePickerController to go back to your original view controller
            [self dismissViewControllerAnimated:YES completion:nil];
        }
}];
}

- (void)openLibrary {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {\
    if (self.clickedPlant ){
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.plant = self.plantToView;
        detailVC.delegate = self;
    } else {
        BoardViewController *boardVC = [segue destinationViewController];
        boardVC.board = self.boardToView;
        boardVC.delegate = self;
        boardVC.myBoard = YES;
    }
}


@end
