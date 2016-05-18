//
//  ZoomingIconTransition.m
//  ZoomingTransition
//
//  Created by David Noeda on 4/5/16.
//  Copyright © 2016 Katade. All rights reserved.
//

#import "ZoomingIconTransition.h"

typedef enum : NSUInteger {
    Initial,
    Final,
} TransitionState;


static NSTimeInterval kZoomingIconTransitionDuration = 0.6;
static CGFloat kZoomingIconTransitionZoomedScale = 15.0;
static CGFloat kZoomingIconTransitionBackgroundScale = 0.80;

@implementation ZoomingIconTransition


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kZoomingIconTransitionDuration;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
//    [containerView addSubview:fromViewController.view];
//    [containerView addSubview:toViewController.view];
//    
//    toViewController.view.alpha = 0;
//    
//    [UIView animateWithDuration:duration
//                          delay:0
//         usingSpringWithDamping:1
//          initialSpringVelocity:0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         toViewController.view.alpha = 1;
//                     } completion:^(BOOL finished) {
//                         
//                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//                     }];
    
    UIViewController *backgroundViewController = fromViewController;
    UIViewController *foregroundViewController = toViewController;
    
    if (self.operation == UINavigationControllerOperationPop){
        backgroundViewController = toViewController;
        foregroundViewController = fromViewController;
    }
    
    // Get the image view in the background and foreground view controllers
    UIImageView *backgroundImageView = [(id<ZoomingIconViewControllerDataSource>)backgroundViewController zoomingIconImageViewForTransition:self];
    UIImageView *foregroundImageView = [(id<ZoomingIconViewControllerDataSource>)foregroundViewController zoomingIconImageViewForTransition:self];
    
    // Get the image view in the background and foreground view controllers
    UIView *backgroundColoredView = [(id<ZoomingIconViewControllerDataSource>)backgroundViewController zoomingIconColoredViewForTransition:self];
    UIView *foregroundColoredView = [(id<ZoomingIconViewControllerDataSource>)foregroundViewController zoomingIconColoredViewForTransition:self];

    // Create view snapshots
    // View controller need to be in view hierarchy for snapshotting
    [containerView addSubview:backgroundViewController.view];
    UIView *snapshotOfColoredView = [backgroundColoredView snapshotViewAfterScreenUpdates:NO];
    UIView *snapshotOfImageView = [[UIImageView alloc] initWithImage:backgroundImageView.image];
    snapshotOfImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Setup animation
    backgroundColoredView.hidden = YES;
    backgroundImageView.hidden = YES;
    
    foregroundColoredView.hidden = YES;
    foregroundImageView.hidden = YES;
    
    containerView.backgroundColor = [UIColor whiteColor];
    
//    [containerView addSubview:backgroundViewController.view];
    [containerView addSubview:snapshotOfColoredView];
    [containerView addSubview:foregroundViewController.view];
    [containerView addSubview:snapshotOfImageView];
    
    UIColor *foregroundViewBackgroundColor = foregroundViewController.view.backgroundColor;
    foregroundViewController.view.backgroundColor = [UIColor clearColor];
    
    TransitionState preTransitionState = Initial;
    TransitionState postTransitionState = Final;
    
    if (self.operation == UINavigationControllerOperationPop){
        preTransitionState = Final;
        postTransitionState = Initial;
    }
    
    [self configureViewsForState:preTransitionState containerView:containerView backgroundViewController:backgroundViewController viewsInBackground:@[backgroundColoredView, backgroundImageView] viewsInForeground:@[foregroundColoredView, foregroundImageView] snapshotViews:@[snapshotOfColoredView, snapshotOfImageView]];
    
    // Perform animation
    // need to layout now if we want the correct parameters for frame
    [foregroundViewController.view layoutIfNeeded];
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self configureViewsForState:postTransitionState containerView:containerView backgroundViewController:backgroundViewController viewsInBackground:@[backgroundColoredView, backgroundImageView] viewsInForeground:@[foregroundColoredView, foregroundImageView] snapshotViews:@[snapshotOfColoredView, snapshotOfImageView]];
    } completion:^(BOOL finished) {
        
        backgroundViewController.view.transform = CGAffineTransformIdentity;
        
        [snapshotOfColoredView removeFromSuperview];
        [snapshotOfImageView removeFromSuperview];
        
        backgroundColoredView.hidden = NO;
        foregroundColoredView.hidden = NO;
        
        backgroundImageView.hidden = NO;
        foregroundImageView.hidden = NO;
        
        foregroundViewController.view.backgroundColor = foregroundViewBackgroundColor;
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ([fromVC conformsToProtocol:@protocol(ZoomingIconViewControllerDataSource)] && [toVC conformsToProtocol:@protocol(ZoomingIconViewControllerDataSource)]){
        self.operation = operation;
        return self;
    }else{
        return nil;
    }
    
}


- (void)configureViewsForState:(TransitionState)state containerView:(UIView *)containerView backgroundViewController:(UIViewController *)backgroundViewController viewsInBackground:(NSArray *)viewsInBackground viewsInForeground:(NSArray *)viewsInForeground snapshotViews:(NSArray *)snapshotViews
{
    if (state == Initial) {
        backgroundViewController.view.transform = CGAffineTransformIdentity;
        backgroundViewController.view.alpha = 1;
        
        ((UIView *)snapshotViews[0]).transform = CGAffineTransformIdentity;
        ((UIView *)snapshotViews[0]).frame = [containerView convertRect:((UIView *)viewsInBackground[0]).frame fromView:((UIView *)viewsInBackground[0]).superview];
        ((UIImageView *)snapshotViews[1]).frame = [containerView convertRect:((UIView *)viewsInBackground[1]).frame fromView:((UIView *)viewsInBackground[1]).superview];
        
    }else if (state == Final){
        backgroundViewController.view.transform = CGAffineTransformMakeScale(kZoomingIconTransitionBackgroundScale, kZoomingIconTransitionBackgroundScale);
        backgroundViewController.view.alpha = 0;
        
        ((UIView *)snapshotViews[0]).transform = CGAffineTransformMakeScale(kZoomingIconTransitionZoomedScale, kZoomingIconTransitionZoomedScale);
        ((UIView *)snapshotViews[0]).center = [containerView convertPoint:((UIView *)viewsInForeground[0]).center fromView:((UIView *)viewsInForeground[0]).superview];
        ((UIImageView *)snapshotViews[1]).frame = [containerView convertRect:((UIView *)viewsInForeground[1]).frame fromView:((UIView *)viewsInForeground[1]).superview];
        
    }else{
        
    }
}


@end
