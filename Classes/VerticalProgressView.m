//
//  VerticalProgressView.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "VerticalProgressView.h"

#define PI (3.1415926535)

@implementation VerticalProgressView

@synthesize minValue, maxValue, currentValue;
@synthesize borderColor, barBackgroundColor, barColor;

- (void)setDefaultProperties {
    self.minValue = 0.0;
    self.maxValue = 1.0;
    self.currentValue = 0.0;
    
    self.backgroundColor = [UIColor clearColor];
    self.borderColor = [UIColor darkGrayColor];
    self.barBackgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    self.barColor = [UIColor greenColor];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        [self setDefaultProperties];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self setDefaultProperties];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Grab context to draw on
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Figure out general dimensions
    CGFloat borderWidth = 3.0;
    CGFloat outerArcRadius = self.frame.size.width / 2.0 - borderWidth / 2.0;
    CGFloat innerArcRadius = self.frame.size.width / 2.0 - borderWidth;
    CGPoint topFocus = CGPointMake(self.frame.size.width / 2.0, MIN(self.frame.size.height / 2.0, outerArcRadius + borderWidth / 2.0));
    CGPoint bottomFocus = CGPointMake(self.frame.size.width / 2.0, MAX(self.frame.size.height / 2.0, self.frame.size.height - (outerArcRadius + borderWidth / 2.0)));
    CGFloat fillableHeight = self.frame.size.height - borderWidth * 2.0;
    
    // Draw bar container
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
    
    CGContextAddArc(context, topFocus.x, topFocus.y, outerArcRadius, 0.0, PI, 1);
    CGContextAddArc(context, bottomFocus.x, bottomFocus.y, outerArcRadius, PI, 0.0, 1);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    // Draw background
    CGContextSetFillColorWithColor(context, [self.barBackgroundColor CGColor]);
    
    CGContextAddArc(context, topFocus.x, topFocus.y, innerArcRadius, 0.0, PI, 1);
    CGContextAddArc(context, bottomFocus.x, bottomFocus.y, innerArcRadius, PI, 0.0, 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    // Figure out fill dimensions
    CGFloat fillAmount = self.currentValue / (self.maxValue - self.minValue);
    CGFloat fillHeight = fillAmount * fillableHeight;
    
    // Draw fill
    CGContextSetFillColorWithColor(context, [self.barColor CGColor]);
    if(fillHeight < innerArcRadius) {
        // Fill doesn't leave bottom curve
        
        // Draw bottom curve
        float theta = acosf((innerArcRadius - fillHeight) / innerArcRadius);
        CGContextAddArc(context, bottomFocus.x, bottomFocus.y, innerArcRadius, PI / 2 - theta, PI / 2 + theta, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
    } else if(fillHeight >= innerArcRadius && fillHeight <= (fillableHeight - innerArcRadius)) {
        // Fill hits center segment but not top curve
        
        // Draw bottom curve
        CGContextAddArc(context, bottomFocus.x, bottomFocus.y, innerArcRadius, PI, 0.0, 1);
        CGContextClosePath(context);
        CGContextFillPath(context);
        
        // Draw center segment
        CGContextAddRect(context, CGRectMake(borderWidth, self.frame.size.height - borderWidth - fillHeight, self.frame.size.width - borderWidth * 2.0, fillHeight - innerArcRadius));
        CGContextFillPath(context);
    } else {
        // Fill hits top curve
        
        // Draw bottom curve
        CGContextAddArc(context, bottomFocus.x, bottomFocus.y, innerArcRadius, PI, 0.0, 1);
        CGContextClosePath(context);
        CGContextFillPath(context);
        
        // Draw center segment
        CGContextAddRect(context, CGRectMake(borderWidth, innerArcRadius, self.frame.size.width - borderWidth * 2.0, self.frame.size.height - 2 * innerArcRadius));
        CGContextFillPath(context);
        
        // Draw top curve
        float theta = -1 * acosf((fillHeight - fillableHeight + innerArcRadius) / innerArcRadius);
        CGContextAddArc(context, topFocus.x, topFocus.y, innerArcRadius, 3 * PI / 2 + theta, PI, 1);
        CGContextAddArc(context, topFocus.x, topFocus.y, innerArcRadius, 0.0, 3 * PI / 2 - theta, 1);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
}

- (void)dealloc {
    [borderColor release];
    [barBackgroundColor release];
    [barColor release];
    
    [super dealloc];
}


@end
