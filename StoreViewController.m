//
//  StoreViewController.m
//  pickapic
//
//  Created by Jon on 11/5/15.
//  Copyright © 2015 D&GVentures. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreCollectionViewCell.h"
#import <StoreKit/StoreKit.h>
#import "PAPIAPHelper.h"


@interface StoreViewController ()

@end

@implementation StoreViewController

@synthesize imageArray, collectionView, productsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // remove horrible white space on top of tableview
    
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // back button
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [backButton setImage:[UIImage imageNamed:@"icn_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icn_back_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [backButton setSelected:YES];
    
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    // navbar
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    imageArray = [[NSArray alloc] initWithObjects:@"goofus",@"knucklehead",@"screwball",@"sillypants", nil];
    
    // products array
    
    // productsArray = [NSArray arrayWithObjects:@"com.DGVentures.pickapic.goofus",@"com.DGVentures.pickapic.sillypants",@"com.DGVentures.pickapic.screwball",@"com.DGVentures.pickapic.knucklehead", nil];

}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 16;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // get correct size for cell based on screen size - i want 2 cells per row
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    return CGSizeMake(screenWidth/2 - 30, screenWidth/2 - 30);
}


- (StoreCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // setup store collection view cell
    static NSString *CellIdentifier = @"categoryCell";
    StoreCollectionViewCell *cell = (StoreCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    // add image to cell
    if (indexPath.row <= 3)
    {
        [cell.categoryButton setBackgroundImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:UIControlStateNormal];
    }
    else
    {
        [cell.categoryButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"store%ld", indexPath.row + 1]] forState:UIControlStateNormal];
    }

    cell.categoryButton.tag = indexPath.row;
    
    // [[cell categoryButton] addTarget:self action:@selector(storeCellButtonPress:event:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

#pragma mark - IAP methods

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification
{
    
    NSString * productIdentifier = notification.object;
    [productsArray enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier])
        {
            if ([productIdentifier isEqualToString:@"com.jonbrown.GifBucket.singlebucket1"])
            {
                // do something
            }
            else if ([productIdentifier isEqualToString:@"com.jonbrown.GifBucket.bucketbundle5"])
            {
                // do something
            }
            else if ([productIdentifier isEqualToString:@"com.jonbrown.GifBucket.bucketbundle5"])
            {
                // do something
            }
            else if ([productIdentifier isEqualToString:@"com.jonbrown.GifBucket.gifbucketunlimited"])
            {
                // do something else
            }
           
        }
    }];
    
}

- (IBAction)cellButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 0)
    {
        NSLog(@"First cell pressed");
        
         SKProduct *product = productsArray[0];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
         
    }
    else if (button.tag == 1)
    {
        NSLog(@"Second cell pressed");
        /*
         SKProduct *product = productsArray[1];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
         */
    }
    else if (button.tag == 2)
    {
        NSLog(@"Third cell pressed");
        /*
         SKProduct *product = productsArray[2];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
         */
    }
    else if (button.tag == 3)
    {
        NSLog(@"Fourth cell pressed");
        /*
         SKProduct *product = productsArray[3];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
         */
    }
}


@end
