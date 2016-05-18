//
//  ViewController.m
//  ZoomingTransition
//
//  Created by David Noeda on 4/5/16.
//  Copyright © 2016 Katade. All rights reserved.
//

#import "MenuViewController.h"

#import "DetailViewController.h"
#import "ItemCell.h"

@interface MenuViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end



@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(100.0, 0, 0, 0);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        
        case 1:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    
    CGFloat cellWidth = layout.itemSize.width;
    
    NSInteger numberOfCells = [self.collectionView numberOfItemsInSection:section];
    CGFloat widthOfCells =  [@(numberOfCells) floatValue] * cellWidth + [@(numberOfCells-1) floatValue] * layout.minimumInteritemSpacing;
    
    CGFloat inset = (collectionView.bounds.size.width - widthOfCells) / 2.0;
    
    return UIEdgeInsetsMake(0, inset, 40.0, inset);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    
    DetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - ZoomingViewControllerDataSource

- (UIImageView *)zoomingIconImageViewForTransition:(ZoomingIconTransition *)transition
{
    if (self.selectedIndexPath){
        ItemCell *cell = (ItemCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        return cell.imageView;
    }
    
    return nil;
}


- (UIView *)zoomingIconColoredViewForTransition:(ZoomingIconTransition *)transition
{
    if (self.selectedIndexPath){
        ItemCell *cell = (ItemCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        return cell.coloredView;
    }
    
    return nil;
}



@end
