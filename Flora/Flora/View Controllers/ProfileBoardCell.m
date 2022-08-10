//
//  ProfileBoardCell.m
//  Flora
//
//  Created by Kleo Ku on 7/25/22.
//

#import "ProfileBoardCell.h"
#import "Plant.h"
#import "Elog.h"


@implementation ProfileBoardCell
- (IBAction)tappedBoard:(id)sender {
    [self.delegate didTapBoard:self.board];
}

- (void)setBoard:(Board *)board {
    _board = board;
    self.boardName.text = board.name;
    self.numPlants.text = [[NSString stringWithFormat:@"%li",  board.plantsArray.count] stringByAppendingString:@" plants"];
    
    [self setBoardCoverImage];
}

- (void) setBoardCoverImage {
    [self.board fetchIfNeededInBackground];
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

@end
