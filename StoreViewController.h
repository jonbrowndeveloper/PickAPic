//
//  StoreViewController.h
//  pickapic
//
//  Created by Jon on 11/5/15.
//  Copyright © 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) NSArray *imageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// store properties

@property (nonatomic, strong) NSArray *fetchedCategoryArray;
@property (nonatomic, strong) NSArray *productsArray;

@property (strong, nonatomic) NSArray *prices;
@property (strong, nonatomic) NSArray *productTitles;
@property (strong, nonatomic) NSArray *productDescriptions;
@property (strong, nonatomic) NSArray *pictureNames;

@end
