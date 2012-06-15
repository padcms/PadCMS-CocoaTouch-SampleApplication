//
//  KioskSubviewsFactory.m
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 14.06.12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import "KioskSubviewsFactory.h"
#import "KioskGalleryView.h"
#import "KioskShelfView.h"

@implementation KioskSubviewsFactory

-(NSArray*) subviewsListWithFrame:(CGRect) frame {
    NSArray     *result = nil;
    
    KioskShelfView     *shelfSubview = [[[KioskShelfView alloc] initWithFrame:frame] autorelease];
    
    shelfSubview.tag = [KioskShelfView subviewTag];
    shelfSubview.hidden = YES;
    
    KioskGalleryView     *gallerySubview = [[[KioskGalleryView alloc] initWithFrame:frame] autorelease];
    
    gallerySubview.tag = [KioskGalleryView subviewTag];
    gallerySubview.hidden = YES;
    
    result = [NSArray arrayWithObjects:
              shelfSubview,
              gallerySubview,
              nil];
    
    return result;
}

@end
