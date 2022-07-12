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
    
    NSArray *userLikes = self.user[@"likes"];
    self.likes = [[userLikes reverseObjectEnumerator] allObjects];
    self.boards = self.user[@"boards"];

    
    self.likedCollectionView.dataSource = self;
    self.boardsCollectionView.dataSource = self;
    
    self.likedCollectionView.tag = 1;
    self.boardsCollectionView.tag = 2;
    
    [self.likedCollectionView reloadData];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        LikesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikesCell" forIndexPath:indexPath];
        PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
        [query whereKey:@"plantId" equalTo:self.likes[indexPath.row]];
        query.limit = 1;

        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
            if(results) {
                if(results.count > 0) {
                    Plant *plant = (Plant *)results[0];
                    cell.plantImage.file = plant.image;
                    [cell.plantImage loadInBackground];
                }
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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
