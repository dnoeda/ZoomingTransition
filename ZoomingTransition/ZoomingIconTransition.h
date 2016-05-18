//
//  ZoomingIconTransition.h
//  ZoomingTransition
//
//  Created by David Noeda on 4/5/16.
//  Copyright © 2016 Katade. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface ZoomingIconTransition : NSObject <UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>

@property UINavigationControllerOperation operation;

@end


@protocol ZoomingIconViewControllerDataSource <NSObject>

- (UIView *)zoomingIconColoredViewForTransition:(ZoomingIconTransition *)transition;
- (UIImageView *)zoomingIconImageViewForTransition:(ZoomingIconTransition *)transition;

@end
