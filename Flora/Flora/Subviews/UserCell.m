//
//  UserCell.m
//  Flora
//
//  Created by Kleo Ku on 7/22/22.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.profPic.layer.masksToBounds = false;
    self.profPic.layer.cornerRadius = self.profPic.frame.size.width/2;
    self.profPic.clipsToBounds = true;
    self.profPic.layer.borderWidth = 0.05;
    
    self.followButton.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
