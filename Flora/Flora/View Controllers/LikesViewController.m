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
#import "PFImageView.h"

@interface LikesViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *boardsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *likedCollectionView;

@property (nonatomic, strong)PFUser *user;
@property (nonatomic, strong)NSArray *likes;
@property (nonatomic, strong)NSArray *boards;

@end

@implementation LikesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [PFUser currentUser];
    self.likes = self.user[@"likes"];
    self.boards = self.user[@"boards"];

    
    self.likedCollectionView.dataSource = self;
    self.boardsCollectionView.dataSource = self;
    
    self.likedCollectionView.tag = 1;
    self.boardsCollectionView.tag = 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        LikesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikesCell" forIndexPath:indexPath];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Post"];
        [query whereKey:@"plantId" equalTo:self.likes[indexPath.row]];
        query.limit = 1;

        // fetch data asynchronously
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
            if(results) {
                Plant *plant = (Plant *)results[0];
                cell.plantImage.file = plant.image;
                [cell.plantImage loadInBackground];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        return cell;
    } else {
        return nil;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView.tag == 1) {
        return self.likes.count;

    } else {
        return 0;
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
