//
//  BoardCell.m
//  Flora
//
//  Created by Kleo Ku on 7/12/22.
//

#import "BoardCell.h"
#import "Plant.h"

@implementation BoardCell

- (void)setBoard:(Board *)board {
    _board = board;
    self.boardName.text = board.name;
    self.numPlants.text = [[NSString stringWithFormat:@"%li",  board.plantsArray.count] stringByAppendingString:@" plants"];
    [self setBoardCoverImage];
}

- (void) setBoardCoverImage {
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
            if(results) {
                if(results.count > 0) {
                    Plant *plant = (Plant *)results[0];
                    self.coverImage.file = plant.image;
                    [self.coverImage loadInBackground];
                } else {
                    NSLog(@"Error getting board cover image: %@", error.localizedDescription);
                }
            }
        }];
    } else {
        [self.coverImage setImage:[UIImage systemImageNamed:@"plus"]];
        [self.coverImage setBackgroundColor:[UIColor systemGray5Color]];
        [self.coverImage setTintColor:[UIColor systemGray4Color]];
    }
}

# pragma mark - Likes View Controller Delegate

- (void) tappedEdit {
    self.deleteButton.contentMode = UIViewContentModeScaleAspectFill;
    self.deleteButton.layer.masksToBounds = false;
    self.deleteButton.layer.cornerRadius = self.deleteButton.frame.size.width/2;
    [self.deleteButton setHidden:NO];
}

- (void) stoppedEdit {
    [self.deleteButton setHidden:YES];
}

#pragma mark - Actions

- (IBAction)didTapBoard:(id)sender {
    [self.delegate didTapBoard:self.board];
}

- (IBAction)didTapDelete:(id)sender {
    NSString *title = [[NSString alloc] initWithFormat:@"Delete board \"%@\"?", self.board.name];
    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.delegate deleteBoard:self.board.name];
        [self.board deleteInBackground];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [confirmationAlert addAction:cancelAction];
    [confirmationAlert addAction:confirmAction];
    [confirmationAlert setPreferredAction:cancelAction];
    [self.delegate confirmBoardDelete:confirmationAlert];
}


@end
