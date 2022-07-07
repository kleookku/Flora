//
//  CardView.h
//  Flora
//
//  Created by Kleo Ku on 7/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardView : UIView

- (instancetype)initWithPlant:(CGRect)frame plantDict:(NSDictionary *)plant;

@end

NS_ASSUME_NONNULL_END
