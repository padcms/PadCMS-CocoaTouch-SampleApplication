//
//  MainViewController.m
//  PadCMS-CocoaTouch-SampleApplication
//
//  Created by Oleg Zhitnik on 13.06.12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import "MainViewController.h"
#import "PCKioskViewController.h"
#import "PCIssue.h"

@interface MainViewController ()

@property (retain, nonatomic) PCKioskViewController *kioskViewController;

@end

@implementation MainViewController

@synthesize kioskViewController = _kioskViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - PCKioskDataSourceProtocol


- (NSInteger)numberOfRevisions
{
    NSInteger revisionsCount = 0;
    
    NSArray *issues = self.application.issues;
    for (PCIssue *issue in issues)
    {
        revisionsCount += [issue.revisions count];
    }
    
    return revisionsCount;
}

- (NSString *)issueTitleWithIndex:(NSInteger)index
{
    PCRevision *revision = [self revisionWithIndex:index];
    
    if (revision != nil && revision.issue != nil)
    {
        return revision.issue.title;
    }
    
    return @"";
}

- (NSString *)revisionTitleWithIndex:(NSInteger)index
{
    PCRevision *revision = [self revisionWithIndex:index];
    
    if (revision != nil)
    {
        return revision.title;
    }
    
    return @"";
}

- (NSString *)revisionStateWithIndex:(NSInteger)index
{
    return @"";
}

- (BOOL)isRevisionDownloadedWithIndex:(NSInteger)index
{
    PCRevision *revision = [self revisionWithIndex:index];
    
    if (revision)
    {
        return  [revision isDownloaded];
    }
    
    return NO;
}

- (UIImage *)revisionCoverImageWithIndex:(NSInteger)index andDelegate:(id<PCKioskCoverImageProcessingProtocol>)delegate
{
    PCRevision *revision = [self revisionWithIndex:index];
    
    if (revision)
    {
        return  revision.coverImage;
    }
    
    return nil;
}

#pragma mark - PCKioskViewControllerDelegateProtocol

@end
