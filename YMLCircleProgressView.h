//
//  CircleProgressView.h
//  Tourean
//
//  Created by கார்த்திக் கேயன் on 7/30/13.
//  Copyright (c) 2013 vivekrajanna@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMLCircleProgressViewDelegate;

@interface YMLCircleProgressView : UIView

@property (nonatomic, weak) id<YMLCircleProgressViewDelegate> delegate;
@property (nonatomic, assign) BOOL autoUpdateProgressIndicator;
@property (nonatomic, assign) CGFloat currentValue, endValue, progressWidth, stepValue, strokeRadius, sleepAfterEnd;
@property (nonatomic, strong) UIColor *fillColor, *progressColor, *trackColor;
@property (nonatomic, strong) CAShapeLayer *trackLayer, *progressLayer;
@property (nonatomic, strong) UILabel *progressIndicatorLabel;
@property (nonatomic, strong) UIImageView *progressIndicatorImageView;

- (void) prepareToStart;
- (void) stop;
- (void) startProgressWithIntervalInSeconds:(CGFloat)interval stopAt:(CGFloat)stopAt;

@end


@protocol YMLCircleProgressViewDelegate <NSObject>

@optional
- (BOOL) circleProgressViewShouldStartAtEnd:(YMLCircleProgressView *)progressView;
- (void) circleProgressView:(YMLCircleProgressView *)progressView applyLabelStyleAtCurrentValue:(CGFloat)currentValue;

@end
