//
//  KioskGalleryControlElement.m
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 14.06.12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import "KioskGalleryControlElement.h"
#import "PCKioskShelfSettings.h"

@implementation KioskGalleryControlElement

- (void) initCover
{
    // no cover
}

-(void)initLabels
{
    [super initLabels];
    [revisionTitleLabel removeFromSuperview];
    
    CGRect        rect;
    
    rect = issueTitleLabel.frame;
    issueTitleLabel.frame = CGRectMake(0, rect.origin.y, self.bounds.size.width, rect.size.height);
    issueTitleLabel.textAlignment = UITextAlignmentCenter;
    issueTitleLabel.font = [UIFont fontWithName:@"Verdana" size:17];
}

-(void)initButtons
{
    [super initButtons];
    
    CGRect      rect;
    
    rect = downloadButton.frame;
    rect.origin.x = (self.bounds.size.width - rect.size.width)/2;
    rect.origin.y = 50;
    downloadButton.frame = rect;
    
    cancelButton.frame = rect;
    readButton.frame = rect;
    
    rect.origin.y += rect.size.height + 10;
    deleteButton.frame = rect;
}

- (void) initDownloadingProgressComponents
{
    [super initDownloadingProgressComponents];
    
    downloadingProgressView.frame = CGRectMake((self.bounds.size.width - KIOSK_SHELF_CELL_BUTTONS_WIDTH)/2, KIOSK_SHELF_CELL_FIRST_BUTTON_TOP_MARGIN, KIOSK_SHELF_CELL_BUTTONS_WIDTH, 7);
    downloadingInfoLabel.frame = CGRectMake((self.bounds.size.width - KIOSK_SHELF_CELL_BUTTONS_WIDTH)/2, KIOSK_SHELF_CELL_FIRST_BUTTON_TOP_MARGIN + 10, KIOSK_SHELF_CELL_BUTTONS_WIDTH, KIOSK_SHELF_CELL_REVISION_TITLE_HEIGHT);
}

@end
