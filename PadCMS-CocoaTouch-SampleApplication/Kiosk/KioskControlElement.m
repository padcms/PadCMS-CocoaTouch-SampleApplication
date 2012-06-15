//
//  KioskControlElement.m
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 14.06.12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import "KioskControlElement.h"

@implementation KioskControlElement

-(void)initButtons
{
    [super initButtons];
 
    [downloadButton setBackgroundImage:[[UIImage imageNamed:@"kiosk_button_download.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:16] forState:UIControlStateNormal];
    [readButton setBackgroundImage:[[UIImage imageNamed:@"kiosk_button_read.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:16] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"kiosk_button_cancel.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:16] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"kiosk_button_delete.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:16] forState:UIControlStateNormal];

    [downloadButton setTitle:@"Download" forState:UIControlStateNormal];
    [readButton setTitle:@"Read" forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
}

@end
