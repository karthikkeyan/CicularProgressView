//
//  CircleProgressView.m
//  Tourean
//
//  Created by கார்த்திக் கேயன் on 7/30/13.
//  Copyright (c) 2013 vivekrajanna@gmail.com. All rights reserved.
//

#import "YMLCircleProgressView.h"
#import "UIColor+Extension.h"
#import "UIView+Extension.h"

#import <QuartzCore/QuartzCore.h>

@interface YMLCircleProgressView ()

@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) CGFloat newToValue, interval, stopAt;

- (void) changeProgressBar;

@end

@implementation YMLCircleProgressView

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self UISetupViews];
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self UISetupViews];
    }
    return self;
}

- (void) UISetupViews {
    _autoUpdateProgressIndicator = YES;
    
    _currentValue = 0.0;
    _newToValue = 0.0;
    _progressWidth = 2;
    
    _fillColor = [UIColor clearColor];
    _trackColor = [UIColor lightGrayColor];
    _progressColor = [UIColor whiteColor];
    
    
    _trackLayer = [CAShapeLayer layer];
    _trackLayer.lineWidth = _progressWidth;
    _trackLayer.fillColor = _fillColor.CGColor;
    _trackLayer.strokeColor = _trackColor.CGColor;
    [[self layer] addSublayer:_trackLayer];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = _progressColor.CGColor;
    _progressLayer.lineWidth = _progressWidth;
//    _progressLayer.lineCap = @"round";
    [self.layer addSublayer:_progressLayer];
    
    
    _progressIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, _progressWidth, _progressWidth)];
    [_progressIndicatorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];
    [_progressIndicatorLabel setBackgroundColor:[UIColor clearColor]];
    [_progressIndicatorLabel setTextAlignment:NSTextAlignmentCenter];
    [_progressIndicatorLabel setNumberOfLines:3];
    [_progressIndicatorLabel setMinimumScaleFactor:0.5];
    [_progressIndicatorLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:_progressIndicatorLabel];
    
    _progressIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, _progressWidth, _progressWidth)];
    _progressIndicatorImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_progressIndicatorImageView];
}


#pragma mark - Private Methods

- (void) changeProgressBar {
    _currentValue = _currentValue + _stepValue;
    if (_currentValue >= _endValue) {
        _currentValue = _endValue;
    }
    
    CGFloat toValue = _currentValue / _endValue;
    CGFloat start_angle = -M_PI_2;
    CGFloat end_angle = ((2 * M_PI) * toValue) - M_PI_2;
    
    CGFloat radius = (self.innerWidth - (_progressWidth * 2))/2;
    
    _progressIndicatorLabel.frame = CGRectInset(self.bounds, _progressWidth, _progressWidth);
    
    // Progress path circle
    _trackLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
                                                      radius:radius
                                                  startAngle:0
                                                    endAngle:(M_PI * 2)
                                                   clockwise:YES].CGPath;
    _trackLayer.lineWidth = _progressWidth;
    _trackLayer.fillColor = _fillColor.CGColor;
    _trackLayer.strokeColor = _trackColor.CGColor;
    _progressLayer.strokeEnd = 1.0;
    
    
    // Progress indicator Circle
    _progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
                                                 radius:(radius + _strokeRadius) startAngle:start_angle endAngle:end_angle clockwise:YES].CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = _progressColor.CGColor;
    _progressLayer.lineWidth = _progressWidth;
    
    if (_isRunning) {
        if (_currentValue >= _endValue) {
            if ([_delegate respondsToSelector:@selector(circleProgressViewShouldStartAtEnd:)] && [_delegate circleProgressViewShouldStartAtEnd:self]) {
                _currentValue = 0.0;
                
                if (_autoUpdateProgressIndicator) {
                    if ([_delegate respondsToSelector:@selector(circleProgressView:applyLabelStyleAtCurrentValue:)]) {
                        [_delegate circleProgressView:self applyLabelStyleAtCurrentValue:_currentValue];
                    }
                    else {
                        [_progressIndicatorLabel setText:[NSString stringWithFormat:@" %d ", (int)_currentValue]];
                    }
                }
                
                if (_stopAt == _currentValue) {
                    [self stop];
                }
                else {
                    [self performSelector:@selector(changeProgressBar) withObject:nil afterDelay:_interval + _sleepAfterEnd];
                }
            }
            else {
                if (_autoUpdateProgressIndicator) {
                    if ([_delegate respondsToSelector:@selector(circleProgressView:applyLabelStyleAtCurrentValue:)]) {
                        [_delegate circleProgressView:self applyLabelStyleAtCurrentValue:_currentValue];
                    }
                    else {
                        [_progressIndicatorLabel setText:[NSString stringWithFormat:@" %d ", (int)(_endValue - _currentValue)]];
                    }
                }
            }
        }
        else {
            if (_autoUpdateProgressIndicator) {
                if ([_delegate respondsToSelector:@selector(circleProgressView:applyLabelStyleAtCurrentValue:)]) {
                    [_delegate circleProgressView:self applyLabelStyleAtCurrentValue:_currentValue];
                }
                else {
                    [_progressIndicatorLabel setText:[NSString stringWithFormat:@" %d ", (int)(_endValue - _currentValue)]];
                }
            }
            
            if (_stopAt == _currentValue) {
                [self stop];
            }
            else {
                [self performSelector:@selector(changeProgressBar) withObject:nil afterDelay:_interval];
            }
        }
    }
}


#pragma mark - Public Methods

- (void) prepareToStart {
    _progressIndicatorLabel.frame = CGRectInset(self.bounds, _progressWidth, _progressWidth);
    
    CGFloat radius = (self.innerWidth - (_progressWidth * 2))/2;
    _trackLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
                                                       radius:radius startAngle:0 endAngle:(M_PI * 2) clockwise:YES].CGPath;
    _trackLayer.lineWidth = _progressWidth;
    _trackLayer.fillColor = _fillColor.CGColor;
    _trackLayer.strokeColor = _trackColor.CGColor;
    
    if (_autoUpdateProgressIndicator) {
        if ([_delegate respondsToSelector:@selector(circleProgressView:applyLabelStyleAtCurrentValue:)]) {
            [_delegate circleProgressView:self applyLabelStyleAtCurrentValue:_currentValue];
        }
        else {
            [_progressIndicatorLabel setText:[NSString stringWithFormat:@" %d ", (int)(_endValue - _currentValue)]];
        }
    }
    
    CGFloat toValue = _currentValue / _endValue;
    
    if (toValue > 1.0) {
        toValue = 1.0;
    }
    
    CGFloat start_angle = -M_PI_2;
    CGFloat end_angle = ((2 * M_PI) * toValue) - M_PI_2;
    
    // Progress indicator Circle
    _progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
                                                  radius:(radius + _strokeRadius) startAngle:start_angle endAngle:end_angle clockwise:YES].CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = _progressColor.CGColor;
    _progressLayer.lineWidth = _progressWidth;
    _progressLayer.strokeEnd = 1.0;
}

- (void) stop {
    if (_isRunning) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeProgressBar) object:nil];
    }
    
    _isRunning = NO;
    _stopAt = NSIntegerMax;
}

- (void) startProgressWithIntervalInSeconds:(CGFloat)interval stopAt:(CGFloat)stopAt {
    _stopAt = stopAt;
    
    if (_isRunning) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeProgressBar) object:nil];
    }
    
    _isRunning = YES;
    _interval = interval;
    
    if (_autoUpdateProgressIndicator) {
        if ([_delegate respondsToSelector:@selector(circleProgressView:applyLabelStyleAtCurrentValue:)]) {
            [_delegate circleProgressView:self applyLabelStyleAtCurrentValue:_currentValue];
        }
        else {
            [_progressIndicatorLabel setText:[NSString stringWithFormat:@" %d ", (int)(_endValue - _currentValue)]];
        }
    }
    
    if (_stopAt != _currentValue) {
        [self performSelector:@selector(changeProgressBar) withObject:nil afterDelay:_interval];
    }
}

@end
