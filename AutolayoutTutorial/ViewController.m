//
//  ViewController.m
//  AutolayoutTutorial
//
//  Created by Giuseppe Santaniello on 28/08/13.
//  Copyright (c) 2013 Giuseppe Santaniello. All rights reserved.
//

#import "ViewController.h"
#import "myView.h"
#import "NumberView.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *coloredViews; //of myView
@property (nonatomic, strong) NSMutableArray *myViewConstraints; //of NSLayoutConstraint

@end

@implementation ViewController
{
    UIScrollView *scrollView;
    
    NSNumber *padding;
    BOOL scrollViewShowing;

    NSLayoutConstraint *baseLineScrollViewConstraint;
    
}

#pragma mark - Lazy Instatiation
-(NSMutableArray *)myViewConstraints
{
    if(!_myViewConstraints) _myViewConstraints = [[NSMutableArray alloc] init];
    return _myViewConstraints;
}

-(NSMutableArray *)coloredViews
{
    if(!_coloredViews) _coloredViews = [[NSMutableArray alloc] init];
    return _coloredViews;
}

#pragma mark -

#define VIEW_ITEMS 25
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add gesture recognizers to the viewController for animation Layout
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    for(int i=1; i<=VIEW_ITEMS; i++){
        NumberView *nView = [[NumberView alloc] init];
        nView.numberInView = @(i);
        [self.coloredViews addObject:nView];
    }
    
    [self createScrollView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    //NSLog(@"%@-%@",NSStringFromSelector(_cmd), NSStringFromCGSize(scrollView.contentSize));

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        if([@(scrollView.contentOffset.x + scrollView.bounds.size.width) isEqualToNumber:@(scrollView.contentSize.width)]){
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+scrollView.bounds.size.width, scrollView.contentOffset.y);
        }
    }
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGFloat scrollViewHeight = scrollView.bounds.size.height;

    if(scrollViewShowing){
        [UIView animateWithDuration:1.5 animations:^{
            baseLineScrollViewConstraint.constant = scrollViewHeight;
            [self.view layoutIfNeeded];
        }];
    }else {
        [UIView animateWithDuration:1.5 animations:^{

            baseLineScrollViewConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
    
    scrollViewShowing = !scrollViewShowing;
    
}

-(void)createScrollView
{
    if(!scrollView){
        
        UIView *parentView = self.view;
        
        /*----------------------------------------------------------------------------------------------*/
        /* Setup scrollView                                                                             */
        /*----------------------------------------------------------------------------------------------*/
        
        scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor colorWithRed:0.19 green:0.12 blue:0.17 alpha:1.0];
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        scrollView.bounces = NO;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        scrollView.delegate = self;
        
        [parentView addSubview:scrollView];
        
        [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];
        [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[scrollView(==180)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];
        
        baseLineScrollViewConstraint = [NSLayoutConstraint constraintWithItem:scrollView
                                                                    attribute:NSLayoutAttributeBaseline
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:parentView
                                                                    attribute:NSLayoutAttributeBaseline
                                                                   multiplier:1.0
                                                                     constant:180.0];
        
        [parentView addConstraint:baseLineScrollViewConstraint];
        
        /*----------------------------------------------------------------------------------------------*/
        /* Setup NumberView in ScrollView                                                               */
        /*----------------------------------------------------------------------------------------------*/
        
        for(NumberView *view in self.coloredViews){
            [scrollView addSubview:view];
        }
        
        /* Make sure we have at least one view */
        if(![self.coloredViews count])
            return;
        
        padding = @20;
        
        /* Pin the first view to the left edge */
        NumberView *firstView = [self.coloredViews objectAtIndex:0];
        [self.myViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[firstView]" options:0 metrics:NSDictionaryOfVariableBindings(padding) views:NSDictionaryOfVariableBindings(firstView)]];
        
        /* Pin the last view to the right edge weakly*/
        NumberView *lastView = [self.coloredViews lastObject];
        [self.myViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[lastView]-(>=padding@450)-|" options:0 metrics:NSDictionaryOfVariableBindings(padding) views:NSDictionaryOfVariableBindings(lastView)]];
        
        /* Pin all views to each other. Make them all equal width. */
        NumberView *previousView = nil;
        for(NumberView *view in self.coloredViews){
            
            /* Center view vertically in the container */
            NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            [self.myViewConstraints addObject:centerConstraint];
            
            if(previousView){
                /*Space out the views and make them equal width. */
                NSDictionary *views = NSDictionaryOfVariableBindings(previousView, view);
                [self.myViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[previousView]-(padding)-[view]" options:0 metrics:NSDictionaryOfVariableBindings(padding) views:views]];
                [self.myViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[previousView(==view)]" options:0 metrics:nil views:views]];
                
            }
            previousView = view;
        }
        
        [scrollView addConstraints:self.myViewConstraints];
    }
}

@end
