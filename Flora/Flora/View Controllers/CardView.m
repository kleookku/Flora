//
//  CardView.m
//  Flora
//
//  Created by Kleo Ku on 7/6/22.
//

#import "CardView.h"
#import "UIImageView+AFNetworking.h"

@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithPlant:(CGRect)frame plantDict:(NSDictionary *)plant{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        NSString *thumbnailString =  [@"https://plants.sc.egov.usda.gov/ImageLibrary/standard/" stringByAppendingString:plant[@"ProfileImageFilename"]];
        
        NSString *imageUrlString = [thumbnailString stringByReplacingCharactersInRange:NSMakeRange(thumbnailString.length-7, 1) withString:@"s"];
        
        NSLog(@"url is %@", imageUrlString);
        NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = nil;
        [imgView setImageWithURL:imageUrl];
        
        imgView.layer.cornerRadius = 10;
        imgView.frame = CGRectOffset(self.frame, 0, 0 );
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // Corner Radius
    self.layer.cornerRadius = 10.0;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
