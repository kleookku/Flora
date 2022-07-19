//
//  CardView.h
//  Flora
//
//  Created by Kleo Ku on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Plant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CardViewDelegate

- (void)plantClicked:(NSDictionary *)plantDict;

@end

@interface CardView : UIView

@property (nonatomic, strong)NSDictionary *plantDict;
@property (nonatomic, strong)Plant *plant;
@property (nonatomic, strong)id<CardViewDelegate> delegate;

- (instancetype)initWithDict:(CGRect)frame plantDict:(NSDictionary *)plant;

- (instancetype)initWithPlant:(CGRect)frame plant:(Plant *)plant;

- (instancetype)initWithLoad:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
