//
//  GrayView.m
//  TinderCardMechanics
//
//  Created by Robert Figueras on 8/7/14.
//  Copyright (c) 2014 Robert Figueras. All rights reserved.
//

#import "GrayView.h"

@interface GrayView ()
@property CGPoint fingerLocationOnView;
@end

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


@implementation GrayView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
        self.gestureRecognizers = @[panRecognizer];

        self.layer.cornerRadius = 10.0;
    }
    return self;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.centerOfThisView = self.center;
    UITouch *touch = [[touches allObjects]firstObject];
    self.fingerLocationOnView = [touch locationInView:self];
    
    [self.delegate grayViewWasTapped:self];
}


- (void) detectPan:(UIPanGestureRecognizer *) panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panGestureRecognizer translationInView:self.superview];
        self.center = CGPointMake(self.centerOfThisView.x + translation.x,
                                      self.centerOfThisView.y + translation.y);
        [self.delegate grayViewIsMoving:self withFingerTouchLocation:self.fingerLocationOnView];
    }

    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate grayViewEndedMoving:self];
    }
}


@end
