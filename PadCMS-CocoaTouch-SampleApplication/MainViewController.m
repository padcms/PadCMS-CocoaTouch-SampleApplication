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
#import "KioskSubviewsFactory.h"
#import "VersionManager.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "PCApplication.h"
#import "PCDownloadApiClient.h"
#import "PCPathHelper.h"
#import "PCJSONKeys.h"

@interface MainViewController ()
{
        PCApplication* currentApplication;
}

@property (retain, nonatomic) PCKioskViewController *kioskViewController;
@property (nonatomic, retain) PadCMSCoder* padcmsCoder;

- (void) initKiosk;
- (void) initManager;

- (PCRevision*) revisionWithIndex:(NSInteger)index;
- (PCRevision*) revisionWithIdentifier:(NSInteger)identifier;

@end

@implementation MainViewController

@synthesize kioskViewController = _kioskViewController;
@synthesize padcmsCoder = _padcmsCoder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentApplication = nil;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [VersionManager sharedManager];
    [self initManager];
    [self initKiosk];
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

- (void) initManager
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    
    if (currentApplication == nil)
    {
        AFNetworkReachabilityStatus remoteHostStatus = [PCDownloadApiClient sharedClient].networkReachabilityStatus;
        //      NetworkStatus remoteHostStatus = [[VersionManager sharedManager].reachability currentReachabilityStatus];
        if(remoteHostStatus == AFNetworkReachabilityStatusNotReachable)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You must be connected to the Internet." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  [alert show];
                                  [alert release];
        } else {
            PadCMSCoder *padCMSCoder = [[PadCMSCoder alloc] initWithDelegate:self];
            self.padcmsCoder = padCMSCoder;
            [padCMSCoder release];

            if (![self.padcmsCoder syncServerPlistDownload])
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"The list of available magazines could not be downloaded" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }

        NSString *plistPath = [[PCPathHelper pathForPrivateDocuments] stringByAppendingPathComponent:@"server.plist"];
        NSDictionary *plistContent = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if(plistContent == nil)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"The list of available magazines could not be downloaded" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else
            if([plistContent count]==0)
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"The list of available magazines could not be downloaded" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            } else {
                NSDictionary *applicationsList = [plistContent objectForKey:PCJSONApplicationsKey];
                NSArray *keys = [applicationsList allKeys];

                if ([keys count] > 0)
                {
                    NSDictionary *applicationParameters = [applicationsList objectForKey:[keys objectAtIndex:0]];
                    currentApplication = [[PCApplication alloc] initWithParameters:applicationParameters
                                                                     rootDirectory:[PCPathHelper pathForPrivateDocuments]];
                } else {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"The list of available magazines could not be downloaded" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                   [alert show];
                   [alert release];
                }
            }
    }
}

- (void) initKiosk
{
    KioskSubviewsFactory *factory = [[[KioskSubviewsFactory alloc] init] autorelease];
    self.kioskViewController = [[[PCKioskViewController alloc] initWithKioskSubviewsFactory:factory
                                                                                   andFrame:self.view.frame
                                                                              andDataSource:self] autorelease];
    self.kioskViewController.delegate = self;
    self.kioskViewController.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.kioskViewController.view];
}

- (PCRevision*) revisionWithIndex:(NSInteger)index
{
    NSMutableArray *allRevisions = [[[NSMutableArray alloc] init] autorelease];
    
    NSArray *issues = [self getApplication].issues;
    for (PCIssue *issue in issues)
    {
        [allRevisions addObjectsFromArray:issue.revisions];
    }
    
    if (index>=0 && index<[allRevisions count])
    {
        PCRevision *revision = [allRevisions objectAtIndex:index];
        return revision;
    }
    
    return nil;
}

- (PCRevision*) revisionWithIdentifier:(NSInteger)identifier
{
    NSMutableArray *allRevisions = [[[NSMutableArray alloc] init] autorelease];
    
    NSArray *issues = [self getApplication].issues;
    for (PCIssue *issue in issues)
    {
        [allRevisions addObjectsFromArray:issue.revisions];
    }
    
    for(PCRevision *currentRevision in allRevisions)
    {
        if(currentRevision.identifier == identifier) return currentRevision;
    }
    
    return nil;
}

- (PCApplication*) getApplication
{
    return currentApplication;
}

#pragma mark - PCKioskDataSourceProtocol


- (NSInteger)numberOfRevisions
{
    NSInteger revisionsCount = 0;
    
    NSArray *issues = [self getApplication].issues;
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
