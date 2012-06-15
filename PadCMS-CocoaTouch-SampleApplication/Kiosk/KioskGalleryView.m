//
//  KioskGalleryView.m
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 14.06.12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import "KioskGalleryView.h"
#import "KioskGalleryControlElement.h"

@implementation KioskGalleryView

- (PCKioskAbstractControlElement*) newControlElementWithFrame:(CGRect) frame
{
    return [[KioskGalleryControlElement alloc] initWithFrame:frame];
}

@end
