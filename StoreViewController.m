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
    
    imageArray = [[NSArray alloc] initWithObjects:@"2202x2208_goofus",@"2202x2208_knucklehead",@"2202x2208_screwball",@"2202x2208_sillypants", nil];
    
    // products array
    
    [[PAPIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            productsNow = products;
            NSLog(@"Products: %@", products);
        }
    }];
    
    // stop scrolling
    
    collectionView.scrollEnabled = NO;
    

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
    return 4;
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
    
    
    if ((indexPath.row == 0 && [[NSUserDefaults standardUserDefaults] boolForKey:@"goofusUnlocked"]) || (indexPath.row == 1 && [[NSUserDefaults standardUserDefaults] boolForKey:@"knuckleheadUnlocked"]) || (indexPath.row == 2 && [[NSUserDefaults standardUserDefaults] boolForKey:@"screwballUnlocked"]) || (indexPath.row == 3 && [[NSUserDefaults standardUserDefaults] boolForKey:@"sillypantsUnlocked"]))
    {
        cell.categoryButton.alpha = 0.3;
        cell.purchasedLabel.hidden = NO;
        
        cell.categoryButton.enabled = NO;

    }

    
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
    
    // add corner radius and shadow
    
    cell.contentView.layer.cornerRadius = 8.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
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
    
    NSLog(@"product bought: %@", productIdentifier);
    
    [productsArray enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier])
        {


           
        }
    }];
    
    BOOL topicPackIncluded = YES;
    
    NSLog(@"adjusting topic packs...");
    
    if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.goofus"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"goofusUnlocked"];
        NSLog(@"goofus unlocked");
    }
    else if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.knucklehead"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"knuckleheadUnlocked"];
        NSLog(@"knucklehead unlocked");
        
    }
    else if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.screwball"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"screwballUnlocked"];
        NSLog(@"screwball unlocked");
        
    }
    else if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.sillypants"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"sillypantsUnlocked"];
        NSLog(@"sillypants unlocked");
        
    }
    
    [self.collectionView reloadData];
    
}

- (IBAction)cellButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 0 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"goofusUnlocked"])
    {
        NSLog(@"First cell pressed");
        
        
        SKProduct *product = productsNow[0];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
         
    }
    else if (button.tag == 1 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"knuckleheadUnlocked"])
    {
        NSLog(@"Second cell pressed");
        
         SKProduct *product = productsNow[1];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
        
    }
    else if (button.tag == 2 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"screwballUnlocked"])
    {
        NSLog(@"Third cell pressed");
        
         SKProduct *product = productsNow[2];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
        
    }
    else if (button.tag == 3 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"sillypantsUnlocked"])
    {
        NSLog(@"Fourth cell pressed");
        
         SKProduct *product = productsNow[3];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
        
    }
}


@end
