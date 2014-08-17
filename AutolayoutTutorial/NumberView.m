//
//  NumbersView.m
//  ScrollingNumbers
//
//  Created by Giuseppe Santaniello on 06/08/13.
//  Copyright (c) 2013 Giuseppe Santaniello. All rights reserved.
//

#import "NumberView.h"
#import "UIColor+Random.h"

@interface NumberView()
@property (nonatomic, strong) UIColor *bkgColor;
@end

@implementation NumberView

@synthesize numberInView = _numberInView;

- (void)setup
{
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    [self setUserInteractionEnabled:YES];
    _bkgColor = [UIColor randomColor];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(==110)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(==160)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

-(void)setNumberInView:(NSNumber *)numberInView
{
    _numberInView = numberInView;
    [self setNeedsDisplay];
}

-(void)setBkgColor:(UIColor *)bkgColor
{
    _bkgColor = bkgColor;
    [self setNeedsDisplay];
}

//-(UIColor *)bkgColor
//{
//    if(!_bkgColor) _bkgColor = [UIColor brownColor];
//    return _bkgColor;
//}

-(NSNumber *)numberInView
{
    if(!_numberInView) _numberInView = [NSNumber numberWithInteger:0];
    return _numberInView;
}

#pragma mark - Drawing

#define CORNER_RADIUS 12.0
//#define STROKE_WIDTH 10.0
#define NUMBER_FONT_SCALE_FACTOR 0.4
#define INSIDE_RECT_SCALE_FACTOR 0.05
- (void)drawRect:(CGRect)rect
{
    // Draw external border
    CGRect outRect = self.bounds;
    UIBezierPath *outPathRect = [UIBezierPath bezierPathWithRoundedRect:outRect cornerRadius:CORNER_RADIUS];
    
    [outPathRect addClip]; 
    
    [[UIColor whiteColor] setFill];
    UIRectFill(outRect);
    
    // Draw inside Rect
    CGRect inRect = CGRectInset(outRect, outRect.size.height * INSIDE_RECT_SCALE_FACTOR, outRect.size.height * INSIDE_RECT_SCALE_FACTOR);
    [self.bkgColor setFill];
    UIRectFill(inRect);

    CGPoint inRectMidPoint = CGPointMake(inRect.origin.x + inRect.size.width/2, inRect.origin.y + inRect.size.height/2);
    CGPoint outRectCenter = CGPointMake(outRect.origin.x + outRect.size.width/2, outRect.origin.y + outRect.size.height/2);
    CGFloat circleRadius = inRect.size.width/2;
    
    //Draw inside Circle
    UIBezierPath *inPathCircle = [UIBezierPath bezierPathWithArcCenter:inRectMidPoint
                                                                radius:circleRadius
                                                            startAngle:0
                                                              endAngle:2*M_PI
                                                             clockwise:YES];
    [[UIColor whiteColor] setStroke];
    inPathCircle.lineWidth = outRect.size.height * INSIDE_RECT_SCALE_FACTOR;//STROKE_WIDTH;
    [inPathCircle stroke];
    
    //Draw number
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *numberFont = [UIFont systemFontOfSize:outRect.size.width * NUMBER_FONT_SCALE_FACTOR];
    
    NSAttributedString *numberText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", [self.numberInView integerValue] ]
                                                                     attributes:@{ NSParagraphStyleAttributeName : paragraphStyle,
                                                                                             NSFontAttributeName : numberFont,
                                                                                  NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                      NSStrokeColorAttributeName : [UIColor grayColor],
                                                                                      NSStrokeWidthAttributeName : @-3}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(outRectCenter.x - numberText.size.width/2, outRectCenter.y - numberText.size.height/2);
    textBounds.size = [numberText size];
    [numberText drawInRect:textBounds];
    

}

/*
-(void)handleTwoFingerTap:(UITapGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        self.bkgColor = [UIColor randomColor];
    }

}
*/

@end
