//
//  KioskShelfView.m
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 14.06.12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import "KioskShelfView.h"
#import "KioskControlElement.h"

@implementation KioskShelfView

- (PCKioskAbstractControlElement*) newCellWithFrame:(CGRect) frame;
{
    return [[KioskControlElement alloc] initWithFrame:frame];
}

@end
