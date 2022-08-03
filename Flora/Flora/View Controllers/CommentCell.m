//
//  CommentCell.m
//  Flora
//
//  Created by Kleo Ku on 8/3/22.
//

#import "CommentCell.h"
#import "DateTools/DateTools.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.profileImage.layer.masksToBounds = false;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = true;
    self.profileImage.layer.borderWidth = 0.05;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(Comment *)comment {
    _comment = comment;
    [comment fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.text.text = comment.text;
        self.createdAt.text = [comment.createdAt shortTimeAgoSinceNow];
        [comment.author fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            self.profileImage.file = comment.author[@"profilePic"];
            [self.profileImage loadInBackground];
            self.username.text = comment.author.username;
        }];
    }];
}

- (IBAction)didTapProfile:(id)sender {
    [self.delegate displayProfile:self.comment.author];
}

@end
