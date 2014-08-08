//
//  ViewController.m
//  TinderCardMechanics
//
//  Created by Robert Figueras on 8/7/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "ViewController.h"
#import "GrayView.h"

@interface ViewController () <GrayViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *thresholdView;
@property (strong, nonatomic) IBOutlet GrayView *theGrayView;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property CGAffineTransform originalTransform;
@property UIDynamicAnimator *dynamicAnimator;
@property UISnapBehavior *snapBehavior;
@property CGPoint originalFrameLocationCenter;
@property CGRect originalFrameLocation;
@property CGFloat fingerTouchHalfwayThreshold;
@end

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
directionToAnimate theAnimationDirection;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.originalTransform = self.theGrayView.transform;
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.theGrayView.delegate = self;
    self.originalFrameLocation = self.theGrayView.frame;
    self.originalFrameLocationCenter = self.theGrayView.center;
    self.fingerTouchHalfwayThreshold = self.theGrayView.frame.size.height/2;
    self.resetButton.enabled = NO;

    // added the snap behavior to initially center the frame
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.theGrayView snapToPoint:self.originalFrameLocationCenter];
    [self.dynamicAnimator addBehavior:self.snapBehavior];
}

#pragma mark - GrayView Delegate methods

-(void)grayViewWasTapped:(id)theGrayView
{
    [self.dynamicAnimator removeAllBehaviors];
}


-(void)grayViewIsMoving:(id)theGrayView withFingerTouchLocation:(CGPoint)fingerTouchLocation
{
    double rads = DEGREES_TO_RADIANS(((self.theGrayView.center.x-self.view.center.x)/10));
    if (fingerTouchLocation.y > self.fingerTouchHalfwayThreshold)
    {
        rads = DEGREES_TO_RADIANS(-((self.theGrayView.center.x-self.view.center.x)/10));
    }
    CGAffineTransform rotationTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
    self.theGrayView.transform = rotationTransform;

    CGFloat thresholdRightEdge =self.thresholdView.frame.origin.x + self.thresholdView.frame.size.width;
    self.theGrayView.yesLabel.alpha = ((self.theGrayView.center.x-self.view.center.x)/(thresholdRightEdge-self.view.center.x));
    self.theGrayView.noLabel.alpha = ((self.view.center.x-self.theGrayView.center.x)/self.thresholdView.frame.origin.x);
}


-(void)grayViewEndedMoving:(id)theGrayView
{
    if (CGRectContainsPoint(self.thresholdView.frame, self.theGrayView.center))
    {
        self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.theGrayView snapToPoint:self.originalFrameLocationCenter];
        [self.dynamicAnimator addBehavior:self.snapBehavior];
        self.theGrayView.yesLabel.alpha = 0.0;
        self.theGrayView.noLabel.alpha = 0.0;
    }
    else
    {
        if (self.theGrayView.center.x<self.thresholdView.frame.origin.x)
        {
            [self animateGrayViewOffScreen:TO_THE_LEFT];
        }
        else
        {
            [self animateGrayViewOffScreen:TO_THE_RIGHT];
        }
    }
}


#pragma mark - animation helper methods

- (IBAction) resetGrayViewBackToCenter
{
    self.theGrayView.transform = self.originalTransform;
    self.theGrayView.frame = self.originalFrameLocation;
    self.resetButton.enabled = NO;
    self.theGrayView.yesLabel.alpha = 0.0;
    self.theGrayView.noLabel.alpha = 0.0;
}


- (void) animateGrayViewOffScreen:(directionToAnimate) directionToAnimate
{
    CGRect newFrame = self.theGrayView.frame;

    if (directionToAnimate == TO_THE_LEFT)
    {
        newFrame.origin.x -= 1000;
    }
    else if (directionToAnimate == TO_THE_RIGHT)
    {
        newFrame.origin.x += 1000;
    }
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.theGrayView.frame = newFrame;
                     }];

    self.resetButton.enabled = YES;
}

@end
