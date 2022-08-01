//
//  ComposeViewController.m
//  Flora
//
//  Created by Kleo Ku on 7/29/22.
//

#import "ComposeViewController.h"
#import "Parse/PFImageView.h"
#import "Parse/Parse.h"
#import "Plant.h"
#import "ComposePlantCell.h"
#import "Post.h"
#import "UITextView_Placeholder/UITextView+Placeholder.h"

@interface ComposeViewController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ComposePlantCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *imagePickerButton;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIAlertController *addPictureAlert;
@property (nonatomic, strong) UIAlertController *noCameraAlert;

@property (nonatomic, strong) NSArray *plants;
@property (nonatomic, strong) UIAlertController *selectWarning;
@property (nonatomic, strong) UIAlertController *noPlantWarning;

@end

@implementation ComposeViewController

@synthesize selectedPlant;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAddPictureAlert];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.selectedPlant = nil;
    
    self.selectWarning = [UIAlertController alertControllerWithTitle:@"Please select only one plant" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [self.selectWarning addAction:okAction];
    
    self.noPlantWarning = [UIAlertController alertControllerWithTitle:@"Post incomplete" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *plantOkAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [self.noPlantWarning addAction:plantOkAction];
    
    [self updatePlants:@""];
    self.captionTextView.placeholder = @"Write a caption...";
}

#pragma mark - Actions

- (IBAction)didTapPickImage:(id)sender {
    [self presentViewController:self.addPictureAlert animated:YES completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    if(self.selectedPlant && self.postImage.image) {
        [Post postUserImage:self.postImage.image withCaption:self.captionTextView.text withPlant:self.selectedPlant withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if(error) {
                    NSLog(@"Error sharing post: %@", error.localizedDescription);
                } else {
                    [self.delegate didPost];
                    NSLog(@"Successfully shared post!");
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
        }];
    } else {
        [self presentViewController:self.noPlantWarning animated:YES completion:nil];
    }
}
- (IBAction)tapped:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - ComposePlantCellDelegate

- (void)selectedPlant:(Plant *)plant {
    self.selectedPlant = plant;
}

- (void)unselectedPlant:(Plant *)plant {
    self.selectedPlant = nil;
}

- (void)presentWarning {
    [self presentViewController:self.selectWarning animated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updatePlants:[searchText lowercaseString]];
}

- (void)updatePlants:(NSString *)searchText {
    PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
    NSString *lowercaseText = [searchText lowercaseString];
    [query whereKey:@"name" containsString:lowercaseText];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting search results: %@", error.localizedDescription);
        } else {
            NSMutableArray *results = [[NSMutableArray alloc] init];
            for(Plant *plant in objects){
                [results addObject:plant];
            }
            self.plants = results;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDelegate

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ComposePlantCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComposePlantCell" forIndexPath:indexPath];
    cell.delegate = self;
    Plant *plant = self.plants[indexPath.row];
    cell.plant = plant;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.plants.count;
}

#pragma mark - Alerts

- (void)setupAddPictureAlert {
    self.addPictureAlert = [UIAlertController alertControllerWithTitle:@"Select Profile Picture" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    UIAlertAction *takePictureAction = [UIAlertAction actionWithTitle:@"Take a Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    
    UIAlertAction *choosePictureAction = [UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openLibrary];
    }];
    
    // add the OK action to the alert controller
    [self.addPictureAlert addAction:takePictureAction];
    [self.addPictureAlert addAction:choosePictureAction];
    [self.addPictureAlert addAction:cancelAction];
    
    self.addPictureAlert.preferredAction = cancelAction;
}

#pragma mark - Image Select

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    if(editedImage){
        UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(500, 500)];
        self.postImage.image = resizedImage;
    } else {
        UIImage *resizedImage = [self resizeImage:originalImage withSize:CGSizeMake(500, 500)];
        self.postImage.image = resizedImage;
    }
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
