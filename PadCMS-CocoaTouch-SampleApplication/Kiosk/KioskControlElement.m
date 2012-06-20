//
//  KioskControlElement.m
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
