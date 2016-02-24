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
    
    imageArray = [[NSArray alloc] initWithObjects:@"Goofus",@"Knucklehead",@"Screwball",@"Sillypants",@"Dingleberry",@"Greenhorn",@"Nitwit",@"Jabroni", nil];
    
    for (int i = 0; i<imageArray.count; i++)
    {
        [self topicPacksUnlocked:imageArray[i]];
    }
    
    // products array
    
    [[PAPIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            productsNow = products;
            NSLog(@"Products: %@", productsArray);
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
    
    
    /*
    if ((indexPath.row == 0 && [[NSUserDefaults standardUserDefaults] boolForKey:@"GoofusUnlocked"]) || (indexPath.row == 1 && [[NSUserDefaults standardUserDefaults] boolForKey:@"KnuckleheadUnlocked"]) || (indexPath.row == 2 && [[NSUserDefaults standardUserDefaults] boolForKey:@"ScrewballUnlocked"]) || (indexPath.row == 3 && [[NSUserDefaults standardUserDefaults] boolForKey:@"SillypantsUnlocked"]) || (indexPath.row == 4 && [[NSUserDefaults standardUserDefaults] boolForKey:@"DingleberryUnlocked"]) || (indexPath.row == 5 && [[NSUserDefaults standardUserDefaults] boolForKey:@"GreenhornUnlocked"]) || (indexPath.row == 6 && [[NSUserDefaults standardUserDefaults] boolForKey:@"NitwitUnlocked"]) || (indexPath.row == 7 && [[NSUserDefaults standardUserDefaults] boolForKey:@"JabroniUnlocked"]))
    {
        NSLog(@"button at cell %ld has been purchased", (long)indexPath.row);
    }*/
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@Unlocked",imageArray[indexPath.row]]])
    {
        cell.categoryButton.alpha = 0.3;
        cell.purchasedLabel.hidden = NO;
        
        cell.categoryButton.enabled = NO;

    }

    

    [cell.categoryButton setBackgroundImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:UIControlStateNormal];

    NSLog(@"cell tag: %ld", (long)indexPath.row);
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
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"GoofusUnlocked"];
        NSLog(@"unlocking goofus");
    }
    else if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.knucklehead"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"KnuckleheadUnlocked"];
        NSLog(@"unlocking Knucklehead");
        
    }
    else if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.screwball"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"ScrewballUnlocked"];
        NSLog(@"unlocking screwball");
    }
    else if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.sillypants"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"SillypantsUnlocked"];
        NSLog(@"unlocking sillypants");
        
        
    }
    else if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.dingleberry"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"DingleberryUnlocked"];
        NSLog(@"unlocking dingleberry");

        
    }
    else if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.greenhorn"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"GreenhornUnlocked"];
        NSLog(@"unlocking greenhorn");

        
    }
    else if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.nitwit"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"NitwitUnlocked"];
        NSLog(@"unlocking nitwit");
        
    }
    else if ([productIdentifier isEqualToString:@"com.DGVentures.pickapic.jabroni"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"JabroniUnlocked"];
        NSLog(@"unlocking jabroni");
        
    }
    
    [self.collectionView reloadData];
    
}

- (IBAction)cellButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    // the products list coming from iTunesConnect is in a different order than I anticipated... shame
    
    if (button.tag == 0 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"GoofusUnlocked"])
    {
        NSLog(@"First cell pressed");
        
        
        SKProduct *product = productsNow[1];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
         
    }
    else if (button.tag == 1 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"KnuckleheadUnlocked"])
    {
        NSLog(@"Second cell pressed");
        
         SKProduct *product = productsNow[4];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
        
    }
    else if (button.tag == 2 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"ScrewballUnlocked"])
    {
        NSLog(@"Third cell pressed");
        
         SKProduct *product = productsNow[6];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
        
    }
    else if (button.tag == 3 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"SillypantsUnlocked"])
    {
        NSLog(@"Fourth cell pressed");
        
         SKProduct *product = productsNow[7];
         NSLog(@"Buying: %@", product.productIdentifier);
         [[PAPIAPHelper sharedInstance] buyProduct:product];
        
    }
    else if (button.tag == 4 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"DingleberryUnlocked"])
    {
        NSLog(@"Fifth cell pressed");
        
        SKProduct *product = productsNow[0];
        NSLog(@"Buying: %@", product.productIdentifier);
        [[PAPIAPHelper sharedInstance] buyProduct:product];
        
    }
    else if (button.tag == 5 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"GreenhornUnlocked"])
    {
        NSLog(@"Sixth cell pressed");
        
        SKProduct *product = productsNow[2];
        NSLog(@"Buying: %@", product.productIdentifier);
        [[PAPIAPHelper sharedInstance] buyProduct:product];
        
    }
    else if (button.tag == 6 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"NitwitUnlocked"])
    {
        NSLog(@"Seventh cell pressed");
        
        SKProduct *product = productsNow[5];
        NSLog(@"Buying: %@", product.productIdentifier);
        [[PAPIAPHelper sharedInstance] buyProduct:product];
        
    }
    else if (button.tag == 7 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"JabroniUnlocked"])
    {
        NSLog(@"Eighth cell pressed");
        
        SKProduct *product = productsNow[3];
        NSLog(@"Buying: %@", product.productIdentifier);
        [[PAPIAPHelper sharedInstance] buyProduct:product];
        
    }
    
}
@end
