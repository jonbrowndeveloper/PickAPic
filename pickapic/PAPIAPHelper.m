//
//  PAPIAPHelper.m
//  pickapic
//
//  Created by Jon on 11/23/15.
//  Copyright © 2015 D&GVentures. All rights reserved.
//

#import "PAPIAPHelper.h"

@implementation PAPIAPHelper

+ (PAPIAPHelper *)sharedInstance
{
    static dispatch_once_t once;
    static PAPIAPHelper * sharedInstance;
    
    
    
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
                                     @"com.DGVentures.pickapic.goofus",
                                     @"com.DGVentures.pickapic.knucklehead",
                                     @"com.DGVentures.pickapic.screwball",
                                     @"com.DGVentures.pickapic.sillypants",
                                     @"com.DGVentures.pickapic.dingleberry",
                                     @"com.DGVentures.pickapic.greenhorn",
                                     @"com.DGVentures.pickapic.nitwit",
                                     @"com.DGVentures.pickapic.jabroni",
                                     nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
        
        
        
    });
    return sharedInstance;
}

@end
