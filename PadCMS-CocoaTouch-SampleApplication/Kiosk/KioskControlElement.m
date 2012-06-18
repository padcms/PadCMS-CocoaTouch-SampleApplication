//
//  KioskControlElement.m
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 14.06.12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import "KioskControlElement.h"
#import "PCKioskShelfSettings.h"

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
    
    CGRect      rect = readButton.frame;
    rect.origin.y += rect.size.height + 10;
    deleteButton.frame = rect;
}

- (void) initDownloadingProgressComponents
{
    [super initDownloadingProgressComponents];
    
    downloadingInfoLabel.frame = CGRectMake(downloadingProgressView.frame.origin.x,
                                            downloadingProgressView.frame.origin.y + downloadingProgressView.frame.size.height + 10,
                                            downloadingProgressView.frame.size.width,
                                            KIOSK_SHELF_CELL_REVISION_TITLE_HEIGHT);
}

@end
