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
    CGFloat _labelIncrement;
    UIColor * borderColor;
    UIColor * barBackgroundColor;
    UIColor * barColor;
}

@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat currentValue;

@property (nonatomic, assign) CGFloat labelIncrement;

@property (nonatomic, retain) UIColor * borderColor;
@property (nonatomic, retain) UIColor * barBackgroundColor;
@property (nonatomic, retain) UIColor * barColor;

@end
