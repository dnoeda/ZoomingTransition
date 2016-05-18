//
//  DetailViewController.m
//  ZoomingTransition
//
//  Created by David Noeda on 4/5/16.
//  Copyright © 2016 Katade. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIView *coloredView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)handleBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ZoomingViewControllerDataSource

- (UIImageView *)zoomingIconImageViewForTransition:(ZoomingIconTransition *)transition
{
    return self.imageView;
}


- (UIView *)zoomingIconColoredViewForTransition:(ZoomingIconTransition *)transition
{
    return self.coloredView;
}


@end
