//
//  myView.m
//  AutolayoutTutorial
//
//  Created by Giuseppe Santaniello on 31/08/13.
//  Copyright (c) 2013 Giuseppe Santaniello. All rights reserved.
//

#import "myView.h"
#import "UIColor+Random.h"

@implementation myView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor randomColor]];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(==110)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(==180)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    }
    return self;
}

-(id)init
{
    return [self initWithFrame:CGRectZero];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
