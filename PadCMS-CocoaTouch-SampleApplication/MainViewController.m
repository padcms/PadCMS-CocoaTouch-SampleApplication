//
//  MainViewController.m
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 13.06.12.
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

#import "MainViewController.h"
#import "PCKioskViewController.h"
#import "KioskSubviewsFactory.h"
#import "KioskGalleryView.h"
#import "KioskShelfView.h"
#import "PCStoreController.h"

@interface MainViewController ()
@property (retain, nonatomic) PCKioskViewController *kioskViewController;
@end

@implementation MainViewController
@synthesize kioskChangeModeButton = _kioskChangeModeButton;
@synthesize kioskViewController = _kioskViewController;
@synthesize kioskView = _kioskView;
@synthesize storeController = _storeController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationNone];
    
}

- (void)viewDidUnload
{
    [self setKioskChangeModeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void) displayIssues
{
    if (!self.kioskViewController)
    {
      KioskSubviewsFactory *factory = [[[KioskSubviewsFactory alloc] init] autorelease];
      self.kioskViewController = [[[PCKioskViewController alloc] initWithKioskSubviewsFactory:factory
                                                                                     andFrame:self.kioskView.bounds
                                                                                andDataSource:self.storeController] autorelease];
      self.kioskViewController.delegate = self.storeController;
      self.kioskViewController.view.backgroundColor = [UIColor clearColor];
      
      [self.kioskView addSubview:self.kioskViewController.view];

    }
    else
    {
      [self reloadSubviews];
    }
}

- (IBAction)kioskChangeModeTapped:(id)sender
{
    if([self.kioskViewController currentSubviewTag]==[KioskGalleryView subviewTag])
    {
        [_kioskChangeModeButton setBackgroundImage:[UIImage imageNamed:@"icon_gallery.png"] forState:UIControlStateNormal];
    } else {
        [_kioskChangeModeButton setBackgroundImage:[UIImage imageNamed:@"icon_shelf.png"] forState:UIControlStateNormal];
    }
    
    [self.kioskViewController switchToNextSubview];
}

- (void) updateRevisionWithIndex:(NSInteger)index
{
  [self.kioskViewController updateRevisionWithIndex:index];
}

- (void) downloadStartedWithRevisionIndex:(NSInteger)index
{
  [self.kioskViewController downloadStartedWithRevisionIndex:index];
}

- (void) downloadFinishedWithRevisionIndex:(NSInteger)index
{
  [self.kioskViewController downloadStartedWithRevisionIndex:index];
}

- (void) downloadFailedWithRevisionIndex:(NSInteger)index
{
  [self.kioskViewController downloadFailedWithRevisionIndex:index];
}

- (void) downloadCanceledWithRevisionIndex:(NSInteger)index
{
  [self.kioskViewController downloadCanceledWithRevisionIndex:index];
}

- (void) downloadingProgressChangedWithRevisionIndex:(NSInteger)index andProgess:(float) progress
{
  [self.kioskViewController downloadingProgressChangedWithRevisionIndex:index andProgess:progress];
}

- (void) deviceOrientationDidChange
{
  [self.kioskViewController deviceOrientationDidChange];
}

- (void) reloadSubviews;
{
  [self.kioskViewController reloadSubviews];
}

- (void)dealloc {
    [_kioskChangeModeButton release];
    [super dealloc];
}
@end
