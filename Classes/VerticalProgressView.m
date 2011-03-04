//
//  VerticalProgressView.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "VerticalProgressView.h"

@implementation VerticalProgressView

@synthesize minValue = _minValue, maxValue = _maxValue, currentValue = _currentValue;
@synthesize labelIncrement = _labelIncrement;
@synthesize borderColor, barBackgroundColor, barColor;

- (void)setDefaultProperties {
    self.minValue = 0.0;
    self.maxValue = 1.0;
    self.currentValue = 0.0;
    self.labelIncrement = 0.0;
    
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
    //CGContextRef originalContext = context;
    
    // Figure out general dimensions
    CGFloat borderWidth = 3.0;
    CGFloat outerArcRadius = self.frame.size.width / 2.0 - borderWidth / 2.0;
    CGFloat innerArcRadius = self.frame.size.width / 2.0 - borderWidth;
    CGPoint topFocus = CGPointMake(self.frame.size.width / 2.0, MIN(self.frame.size.height / 2.0, outerArcRadius + borderWidth / 2.0));
    CGPoint bottomFocus = CGPointMake(self.frame.size.width / 2.0, MAX(self.frame.size.height / 2.0, self.frame.size.height - (outerArcRadius + borderWidth / 2.0)));
    CGFloat fillableHeight = self.frame.size.height - borderWidth * 2.0;
    
    // Draw background
    CGContextSetFillColorWithColor(context, [self.barBackgroundColor CGColor]);
    
    CGContextAddArc(context, topFocus.x, topFocus.y, innerArcRadius, 0.0, M_PI, 1);
    CGContextAddArc(context, bottomFocus.x, bottomFocus.y, innerArcRadius, M_PI, 0.0, 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    // Figure out fill dimensions
    CGFloat fillAmount = self.currentValue / (self.maxValue - self.minValue);
    CGFloat fillHeight = fillAmount * fillableHeight;
    //NSLog(@"Filling to height %f", fillHeight);
    
    // Draw bar container
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
    
    CGContextAddArc(context, topFocus.x, topFocus.y, outerArcRadius, 0.0, M_PI, 1);
    CGContextAddArc(context, bottomFocus.x, bottomFocus.y, outerArcRadius, M_PI, 0.0, 1);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    // Draw gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t nLocations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {0.0/255.0, 146.0/255.0, 74.0/255.0, 1.0, 132.0/255.0, 198.0/255.0, 77.0/255.0, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, nLocations);
    
    CGRect bounds = CGRectMake(0.0, fillHeight, self.frame.size.width, self.frame.size.height);
    CGPoint midLeft = CGPointMake(0.0, CGRectGetMidY(bounds));
    CGPoint midRight = CGPointMake(self.frame.size.width, CGRectGetMidY(bounds));
    
    // Draw increments
    if(self.labelIncrement != 0.0) {
        for(int i = 1; i < (int)floorf(self.maxValue / self.labelIncrement); i++) {
            CGFloat markHeight = i * self.labelIncrement * fillableHeight / (self.maxValue - self.minValue);
            //NSLog(@"Marking at height %f", markHeight);
            
            CGContextSetLineWidth(context, 1.0);
            CGContextMoveToPoint(context, 0.0, self.frame.size.height - markHeight);
            CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - markHeight);
            CGContextStrokePath(context);
            
            //CGContextSelectFont(context, "Arial", 12.0, kCGEncodingMacRoman);
            //CGContextShowTextAtPoint(context, 4.0, self.frame.size.height - markHeight + 4.0, [[NSString stringWithFormat:@"%d GB", i] cStringUsingEncoding:NSASCIIStringEncoding], 4);
        }
    }
    
    CGContextAddArc(context, topFocus.x, topFocus.y, innerArcRadius, 0.0, M_PI, 1);
    CGContextAddArc(context, bottomFocus.x, bottomFocus.y, innerArcRadius, M_PI, 0.0, 1);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextClipToRect(context, CGRectMake(0.0, self.frame.size.height - fillHeight, self.frame.size.width, self.frame.size.height));
    CGContextDrawLinearGradient(context, gradient, midLeft, midRight, 0);
    
    //context = originalContext;
        
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)dealloc {
    [borderColor release];
    [barBackgroundColor release];
    [barColor release];
    
    [super dealloc];
}


@end
