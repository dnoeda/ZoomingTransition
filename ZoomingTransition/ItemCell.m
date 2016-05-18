//
//  ItemCell.m
//  ZoomingTransition
//
//  Created by David Noeda on 4/5/16.
//  Copyright © 2016 Katade. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell ()

@end


@implementation ItemCell


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coloredView.layer.cornerRadius = self.bounds.size.width/2.0;
    self.coloredView.layer.masksToBounds = YES;
    
}


@end
