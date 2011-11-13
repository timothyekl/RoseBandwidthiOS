//
//  VerticalProgressView.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VerticalProgressView : UIView {
    CGFloat _minValue;
    CGFloat _maxValue;
    CGFloat _currentValue;
    NSMutableSet * _labelValues;
    UIColor * borderColor;
    UIColor * barBackgroundColor;
    UIColor * barColor;
}

@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat currentValue;

@property (nonatomic, readonly) NSSet * labelValues;

@property (nonatomic, strong) UIColor * borderColor;
@property (nonatomic, strong) UIColor * barBackgroundColor;
@property (nonatomic, strong) UIColor * barColor;

- (void)addLabelAt:(CGFloat)value;
- (void)removeLabelAt:(CGFloat)value;
- (void)removeAllLabels;

@end
