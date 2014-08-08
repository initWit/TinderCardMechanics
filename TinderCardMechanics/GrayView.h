//
//  GrayView.h
//  TinderCardMechanics
//
//  Created by Robert Figueras on 8/7/14.
//  Copyright (c) 2014 Robert Figueras. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrayViewDelegate
- (void) grayViewWasTapped:(id)theGrayView;
- (void) grayViewIsMoving:(id)theGrayView withFingerTouchLocation:(CGPoint)fingerTouchLocation;
- (void) grayViewEndedMoving: (id)theGrayView;
@end

@interface GrayView : UIView
@property id<GrayViewDelegate> delegate;
@property CGPoint centerOfThisView;
@property (strong, nonatomic) IBOutlet UILabel *yesLabel;
@property (strong, nonatomic) IBOutlet UILabel *noLabel;
@end
