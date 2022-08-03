//
//  SelectBoardCell.m
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import "SelectBoardCell.h"
#import "Plant.h"
#ifdef DEBUG
#    define Elog(...) NSLog(__VA_ARGS__)
#else
#    define Elog(...) /* */
#endif

@implementation SelectBoardCell

- (void)setBoard:(Board *)board {
    _board = board;
    self.coverImage.layer.cornerRadius = 20;
    self.boardName.text = board.name;
    [self setBoardCoverImage];
}

- (void) setBoardCoverImage{
    Board *currentBoard = self.board;
    self.coverImage.layer.cornerRadius = 20;
    if(self.board.coverImage) {
        self.coverImage.file = self.board.coverImage;
        [self.coverImage loadInBackground];
    } else if(self.board.plantsArray.count > 0){
        NSString *plantId = self.board.plantsArray[0];
        PFQuery *query = [PFQuery queryWithClassName:@"Plant"];
        [query whereKey:@"plantId" equalTo:plantId];
        query.limit = 1;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
            if([currentBoard isEqual:self.board]) {
                if(error) {
                    Elog(@"Error getting board cover image: %@", error.localizedDescription);
                } else if (results.count > 0) {
                    Plant *plant = (Plant *)results[0];
                    self.coverImage.file = plant.image;
                    [self.coverImage loadInBackground];
                }
            }
        }];
    } else {
        [self.coverImage setImage:[UIImage systemImageNamed:@"plus"]];
        [self.coverImage setBackgroundColor:[UIColor systemGray5Color]];
        [self.coverImage setTintColor:[UIColor systemGray4Color]];
    }
}

- (IBAction)didTapAddToBoard:(id)sender {
    UIAlertController *confirmationAlert = nil;
    if([self.board[@"plantsArray"] containsObject:self.plantToAdd]){
        confirmationAlert = [UIAlertController alertControllerWithTitle:@"Already exists in this board" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [confirmationAlert addAction:okAction];
        
    } else {
        NSString *title = [@"Add plant to " stringByAppendingString:self.board.name];
        confirmationAlert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self addPlantToBoard];
            [self.delegate updateBoards];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [confirmationAlert addAction:cancelAction];
        [confirmationAlert addAction:confirmAction];
        [confirmationAlert setPreferredAction:cancelAction];
        
    }
    
    [self.delegate confirmAddToBoard:confirmationAlert];
    
}

- (void)addPlantToBoard {
    // save plant to board's plants
    NSMutableArray *plantsArray = [[NSMutableArray alloc] initWithArray:self.board[@"plantsArray"] copyItems:YES];
    [plantsArray addObject:self.plantToAdd];
    self.board[@"plantsArray"] = plantsArray;
    [self.board saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            Elog(@"Error adding plant to board %@", error.localizedDescription);
        }
    }];
}

@end
