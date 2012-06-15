//
//  MainViewController.h
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 13.06.12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCKioskDataSourceProtocol.h"
#import "PCKioskViewControllerDelegateProtocol.h"
#import "PCApplication.h"
#import "PadCMSCoder.h"

@interface MainViewController : UIViewController <PCKioskDataSourceProtocol,
PadCMSCodeDelegate,
PCKioskViewControllerDelegateProtocol>

@property (retain, nonatomic) PCApplication *application;

@property (retain, nonatomic) IBOutlet UIView *kioskView;
- (IBAction)kioskChangeModeTapped:(id)sender;

@end
