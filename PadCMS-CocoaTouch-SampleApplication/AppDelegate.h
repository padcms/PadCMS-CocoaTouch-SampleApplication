//
//  AppDelegate.h
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 13.06.12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *viewController;

@end
