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
#import "PCIssue.h"
#import "KioskSubviewsFactory.h"
#import "VersionManager.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "PCApplication.h"
#import "PCDownloadApiClient.h"
#import "PCPathHelper.h"
#import "PCJSONKeys.h"
#import "PCRevisionViewController.h"
#import "PCDownloadManager.h"
#import "ImageCache.h"
#import "PCResourceCache.h"
#import "KioskGalleryView.h"
#import "KioskShelfView.h"

@interface MainViewController ()
{
        PCApplication* currentApplication;
}

@property (retain, nonatomic) PCKioskViewController *kioskViewController;
@property (nonatomic, retain) PadCMSCoder* padcmsCoder;
@property (nonatomic, retain) PCRevisionViewController *revisionViewController;

- (void) initKiosk;
- (void) initManager;
- (void) switchToKiosk;

- (PCRevision*) revisionWithIndex:(NSInteger)index;
- (PCRevision*) revisionWithIdentifier:(NSInteger)identifier;
- (void)doDownloadRevisionWithIndex:(NSNumber*)index;
- (void)downloadRevisionFinishedWithIndex:(NSNumber*)index;
- (void)downloadRevisionFailedWithIndex:(NSNumber*)index;
- (void)downloadRevisionCanceledWithIndex:(NSNumber*)index;
- (void)downloadingRevisionProgressUpdate:(NSDictionary*)info;
- (void)rotateInterfaceIfNeedWithRevision:(PCRevision*) revision;

@end

@implementation MainViewController
@synthesize kioskChangeModeButton = _kioskChangeModeButton;

@synthesize kioskViewController = _kioskViewController;
@synthesize padcmsCoder = _padcmsCoder;
@synthesize kioskView = _kioskView;
@synthesize revisionViewController = _revisionViewController;
@synthesize application = _application;

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
    [self setKioskChangeModeButton:nil];
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
                                                                                   andFrame:self.kioskView.bounds
                                                                              andDataSource:self] autorelease];
    self.kioskViewController.delegate = self;
    self.kioskViewController.view.backgroundColor = [UIColor clearColor];
    
    [self.kioskView addSubview:self.kioskViewController.view];
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

- (void) switchToKiosk
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[PCResourceCache sharedInstance] removeAllObjects];
    [[ImageCache sharedImageCache] removeAllImages];
    [[PCDownloadManager sharedManager] cancelAllOperations];
    if(_revisionViewController)
    {
        [_revisionViewController.view removeFromSuperview];
        [_revisionViewController release];
        _revisionViewController = nil;
    }
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

- (void) readRevisionWithIndex:(NSInteger)index
{
    PCRevision *currentRevision = [self revisionWithIndex:index];
    
    if (currentRevision)
    {
        [self rotateInterfaceIfNeedWithRevision:currentRevision];
        
        [PCDownloadManager sharedManager].revision = currentRevision;
        [[PCDownloadManager sharedManager] startDownloading];
        
        if (_revisionViewController == nil)
        {
            NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"PadCMS-CocoaTouch-Core-Resources" withExtension:@"bundle"]];

            _revisionViewController = [[PCRevisionViewController alloc] 
                                       initWithNibName:@"PCRevisionViewController"
                                       bundle:bundle];
            
            [_revisionViewController setRevision:currentRevision];
            _revisionViewController.mainViewController = self;
            _revisionViewController.initialPageIndex = 0;
            [self.view addSubview:_revisionViewController.view];
//            self.mainView = _revisionViewController.view;
//            self.mainView.tag = 100;
            
            
        }
    }
}

- (void) deleteRevisionDataWithIndex:(NSInteger)index
{
    PCRevision *revision = [self revisionWithIndex:index];
    
    NSString    *message = [NSString stringWithFormat:@"Etes-vous certain de vouloir supprimer ce numéro ? (%@)", revision.issue.title];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Annuler"
                                          otherButtonTitles:@"Oui", nil];
	alert.delegate = self;
    alert.tag = index;
	[alert show];
	[alert release];
}

- (void) downloadRevisionWithIndex:(NSInteger)index
{
    PCRevision *revision = [self revisionWithIndex:index];
    
    if(revision)
    {
		
		AFNetworkReachabilityStatus remoteHostStatus = [PCDownloadApiClient sharedClient].networkReachabilityStatus;
        //	NetworkStatus remoteHostStatus = [[VersionManager sharedManager].reachability currentReachabilityStatus];
		if(remoteHostStatus == AFNetworkReachabilityStatusNotReachable) 
		{
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Vous devez être connecté à Internet." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
			
		}
        [self.kioskViewController downloadStartedWithRevisionIndex:index];
        [self performSelectorInBackground:@selector(doDownloadRevisionWithIndex:) withObject:[NSNumber numberWithInteger:index]];
    }
}

- (void) cancelDownloadingRevisionWithIndex:(NSInteger)index
{
    PCRevision *revision = [self revisionWithIndex:index];
    
    if(revision)
    {
        [revision cancelDownloading];
    }
}

- (void) updateRevisionWithIndex:(NSInteger) index
{
}

#pragma mark - Download flow

- (void)doDownloadRevisionWithIndex:(NSNumber *)index
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    PCRevision          *revision = [self revisionWithIndex:[index integerValue]];
    
    if(revision)
    {
        [revision download:^{
            [self performSelectorOnMainThread:@selector(downloadRevisionFinishedWithIndex:)
                                   withObject:index
                                waitUntilDone:NO];
        } failed:^(NSError *error) {
            [self performSelectorOnMainThread:@selector(downloadRevisionFailedWithIndex:)
                                   withObject:index
                                waitUntilDone:NO];
        } canceled:^{
            [self performSelectorOnMainThread:@selector(downloadRevisionCanceledWithIndex:)
                                   withObject:index
                                waitUntilDone:NO];
        } progress:^(float progress) {
            NSDictionary        *info = [NSDictionary dictionaryWithObjectsAndKeys:index, @"index", [NSNumber numberWithFloat:progress], @"progress", nil];
            
            [self performSelectorOnMainThread:@selector(downloadingRevisionProgressUpdate:)
                                   withObject:info
                                waitUntilDone:NO];
        }];
    }
    
    
    [pool release];
}

- (void)downloadRevisionCanceledWithIndex:(NSNumber*)index
{
    [self.kioskViewController downloadCanceledWithRevisionIndex:[index integerValue]];
    
    PCRevision      *revision = [self revisionWithIndex:[index integerValue]];
    if(revision)
    {
        [revision deleteContent];
        [self.kioskViewController updateRevisionWithIndex:[index integerValue]];
    }
}

- (void)downloadRevisionFinishedWithIndex:(NSNumber*)index
{
    [self.kioskViewController downloadFinishedWithRevisionIndex:[index integerValue]];
    
}

- (void)downloadRevisionFailedWithIndex:(NSNumber*)index
{
    [self.kioskViewController downloadFailedWithRevisionIndex:[index integerValue]];
    
    UIAlertView *errorAllert = [[UIAlertView alloc] 
                                initWithTitle:NSLocalizedString(@"Error downloading issue!", nil) 
                                message:NSLocalizedString(@"Try again later", nil) 
                                delegate:nil
                                cancelButtonTitle:@"OK" 
                                otherButtonTitles:nil];
    
    [errorAllert show];
    [errorAllert release];
    
    PCRevision      *revision = [self revisionWithIndex:[index integerValue]];
    if(revision)
    {
        [revision deleteContent];
        [self.kioskViewController updateRevisionWithIndex:[index integerValue]];
    }
}

- (void)downloadingRevisionProgressUpdate:(NSDictionary*)info
{
    NSNumber        *index = [info objectForKey:@"index"];
    NSNumber        *progress = [info objectForKey:@"progress"];
    
    [self.kioskViewController downloadingProgressChangedWithRevisionIndex:[index integerValue]
                                                               andProgess:[progress floatValue]];
}

#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1)
	{
        NSInteger       index = alertView.tag;
        PCRevision *revision = [self revisionWithIndex:index];
        
        if(revision)
        {
            PCDownloadManager* manager = [PCDownloadManager sharedManager];
            if (manager.revision == revision)
            {
                [manager cancelAllOperations];
            }
            
            if (revision)
            {
                [[PCResourceCache sharedInstance] removeAllObjects];
                [[ImageCache sharedImageCache] removeAllImages];
                [revision deleteContent];
                [self.kioskViewController updateRevisionWithIndex:index];
            }
        }
	}
}

#pragma mark - misc

- (void)rotateInterfaceIfNeedWithRevision:(PCRevision*) revision
{
    if(revision.horizontalOrientation)
    {
        UIInterfaceOrientation curOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        // if we enter in view controller in portrait with revision with horizontal orientation
        if(UIDeviceOrientationIsPortrait(curOrientation))
        {
            [UIView beginAnimations:@"View Flip" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
            [UIView setAnimationDelegate:self];
            
            self.view.frame = CGRectMake(0.0, 0.0, 1024, 768);
            self.view.center = CGPointMake(512, 384);
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
            CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation( 90.0 * M_PI / -180.0 );
            landscapeTransform = CGAffineTransformTranslate( landscapeTransform, -128.0, -128.0 );
            self.view.transform = landscapeTransform;
            
            [UIView commitAnimations];
        }
    } 
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if([animationID isEqualToString:@"View Flip"])
    {
        [self.kioskViewController deviceOrientationDidChange];
    }
}

- (void)dealloc {
    [_kioskChangeModeButton release];
    [super dealloc];
}
@end
