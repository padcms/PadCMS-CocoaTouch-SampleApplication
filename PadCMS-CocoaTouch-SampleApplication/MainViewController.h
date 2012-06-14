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

@interface MainViewController : UIViewController <PCKioskDataSourceProtocol,
PCKioskViewControllerDelegateProtocol>

/**
 @brief application with revisions to be shown
 */
@property (retain, nonatomic) PCApplication *application;

@end
