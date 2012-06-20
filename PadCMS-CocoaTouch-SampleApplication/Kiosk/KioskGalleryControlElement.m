//
//  KioskGalleryControlElement.m
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 14.06.12.
//  Copyright (c) PadCMS (http://www.padcms.net)
//
//
//  This software is governed by the CeCILL-C  license under French law and
//  abiding by the rules of distribution of free software.  You can  use,
//  modify and/ or redistribute the software under the terms of the CeCILL-C
//  license as circulated by CEA, CNRS and INRIA at the following URL
//  "http://www.cecill.info".
//  
//  As a counterpart to the access to the source code and  rights to copy,
//  modify and redistribute granted by the license, users are provided only
//  with a limited warranty  and the software's author,  the holder of the
//  economic rights,  and the successive licensors  have only  limited
//  liability.
//  
//  In this respect, the user's attention is drawn to the risks associated
//  with loading,  using,  modifying and/or developing or reproducing the
//  software by the user in light of its specific status of free software,
//  that may mean  that it is complicated to manipulate,  and  that  also
//  therefore means  that it is reserved for developers  and  experienced
//  professionals having in-depth computer knowledge. Users are therefore
//  encouraged to load and test the software's suitability as regards their
//  requirements in conditions enabling the security of their systems and/or
//  data to be ensured and,  more generally, to use and operate it in the
//  same conditions as regards security.
//  
//  The fact that you are presently reading this means that you have had
//  knowledge of the CeCILL-C license and that you accept its terms.
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
