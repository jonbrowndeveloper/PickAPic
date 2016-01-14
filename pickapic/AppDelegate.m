//
//  AppDelegate.m
//  PickAPic
//
//  Created by William A. Brown on 6/18/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>
#import "OPIPGameViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize timer, timerValue;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL tutorialHasBeenSeen = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialHasBeenSeen"];
    
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;

    if (!tutorialHasBeenSeen)
    {
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }
    else
    {
        // do nothing
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // [ParseCrashReporting enable];
    
    // Initialize Parse.
    [Parse setApplicationId:@"P0gD8NJp4RKgtZBzvihB5nTZXmeqdfVimDlD4iC1"
                  clientKey:@"mc3mFS6GNdhkvllSq3IsYVfVXVb7NMYf1FhJ4kG0"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"preferencesSet"])
    {
        BOOL preferencesSet = YES;
        [[NSUserDefaults standardUserDefaults] setBool:preferencesSet forKey:@"preferencesSet"];
        
        double gameTimer = 60.0;
        [[NSUserDefaults standardUserDefaults] setDouble:gameTimer forKey:@"gameTimer"];
        
        BOOL rounds = YES;
        [[NSUserDefaults standardUserDefaults] setBool:rounds forKey:@"isRounds"];
        
        BOOL prompts = YES;
        [[NSUserDefaults standardUserDefaults] setBool:prompts forKey:@"gamePromptsActive"];
        
        double numberOfRoundsOrPoints = 5.0;
        [[NSUserDefaults standardUserDefaults] setDouble:numberOfRoundsOrPoints forKey:@"numberOfRoundsOrPoints"];
        
        BOOL tutorialHasBeenSeen = NO;
        [[NSUserDefaults standardUserDefaults] setBool:tutorialHasBeenSeen forKey:@"tutorialHasBeenSeen"];
        
        // for topic packs
        
        BOOL topicPackIncluded = NO;
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"goofusUnlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"knuckleheadUnlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"screwballUnlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:topicPackIncluded forKey:@"sillypantsUnlocked"];

        
    }
    
    // show tutorial view if first time
    
    
    
    // for page indicator
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "DGVentures.PickAPic" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PickAPic" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PickAPic.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

-(void)startTimer
{
    timerValue = (int)[[NSUserDefaults standardUserDefaults] doubleForKey:@"gameTimer"];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(advanceTimer:) userInfo:nil repeats:NO];
}

- (void)advanceTimer:(NSTimer *)timer
{
    
    --timerValue;
    if(self.timerValue >= 0)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(advanceTimer:) userInfo:nil repeats:NO];
        // opipViewController.countdownLabel.text = [NSString stringWithFormat:@"%d", timerValue];
        
        AudioServicesPlaySystemSound(1105);
        
        // NSLog(@"counting down... %d", timerValue);
        
    }
    
    if (self.timerValue == 0)
    {
        // opipViewController.countdownLabel.text = [NSString stringWithFormat:@"0"];
        
        // do something like say the round is over, choose a winner
        
        [self.timer invalidate];
        self.timer = nil;
        
        // possible buzzer
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1005);
        
         // opipViewController.timerHasReachedZero = YES;
        
        // self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadeCountdownOut) userInfo:nil repeats:NO];
    }
    
}



#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
