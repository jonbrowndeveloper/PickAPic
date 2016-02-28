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

@synthesize imageArray, collectionView, productsArray, productsNow;

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
    
    imageArray = [[NSArray alloc] initWithObjects:@"Dingleberry",@"Goofus",@"Greenhorn",@"Jabroni",@"Knucklehead",@"Nitwit",@"Screwball",@"Sillypants", nil];
    
    for (int i = 0; i<imageArray.count; i++)
    {
        [self topicPacksUnlocked:imageArray[i]];
    }
    
    // products array
    
    [[PAPIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success)
        {
            productsNow = products;
            // NSLog(@"Products: %@", productsNow);
            for (int i = 0; i < productsNow.count; i++)
            {
                SKProduct *product = productsNow[i];
                NSLog(@"%@", product.productIdentifier);
            }
            
        }
    }];
    
    // stop scrolling
    
    // collectionView.scrollEnabled = NO;
    

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
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // get correct size for cell based on screen size - i want 2 cells per row
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    return CGSizeMake(screenWidth, screenWidth/2);
}

- (void)topicPacksUnlocked:(NSString *)topicPackName
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@Unlocked", topicPackName]])
    {
        NSLog(@"%@ unlocked", topicPackName);
        
    }
}


- (StoreCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // setup store collection view cell
    static NSString *CellIdentifier = @"categoryCell";
    StoreCollectionViewCell *cell = (StoreCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // check if cell's topic pack has been purchased
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@Unlocked",imageArray[indexPath.row]]])
    {
        NSLog(@"cell %@ at %ld has been purchased", imageArray[indexPath.row],(long)indexPath.row);
        
        cell.categoryButton.alpha = 0.3;
        cell.purchasedLabel.hidden = NO;
        
        cell.categoryButton.enabled = NO;

    }
    // to get rid of bug that is making cells 4 away that have not been purchased, greyed out
    if (![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@Unlocked",imageArray[indexPath.row]]])
    {
        cell.categoryButton.alpha = 1.0;
        cell.purchasedLabel.hidden = YES;
        
        cell.categoryButton.enabled = YES;
    }

    [cell.categoryButton setBackgroundImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:UIControlStateNormal];

    NSLog(@"cell tag: %ld", (long)indexPath.row);
    cell.categoryButton.tag = indexPath.row;
    
    // add corner radius and shadow
    
    cell.contentView.layer.cornerRadius = 0.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
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
    
    NSLog(@"product bought: %@", productIdentifier);
    
    [productsArray enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier])
        {

            
           
        }
    }];
    
    BOOL topicPackIncluded = YES;
    
    NSLog(@"adjusting topic packs...");
    
    for (int i = 0; i<imageArray.count;i++)
    {
        if ([productIdentifier isEqualToString:[NSString stringWithFormat:@"com.DGVentures.pickapic.%@",[[imageArray[i] substringFromIndex:0] lowercaseString]]])
        {
            [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:[NSString stringWithFormat:@"%@Unlocked", imageArray[i]]];
            NSLog(@"unlocking %@", imageArray[i]);
        }
    }
    [self.collectionView reloadData];
    
}

- (IBAction)cellButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@Unlocked",imageArray[button.tag]]])
    {
        SKProduct *product = productsNow[button.tag];
        NSLog(@"Buying: %@", product.productIdentifier);
        [[PAPIAPHelper sharedInstance] buyProduct:product];
    }

}
- (IBAction)restorePreviousPurchases:(id)sender
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    [self.collectionView reloadData];
}
@end
