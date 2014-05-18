#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#include <notify.h>
#import "AFNetworking/AFNetworking.h"
#import "VideoViewController.h"
#import "YTDownloadsViewController.h"
#import "WYPopoverController/WYPopoverController.h"
#import "HCYoutubeParser/HCYoutubeParser.h"
#import "ProgressHUD/ProgressHUD.h"
#import "MTStatusBarOverlay/MTStatusBarOverlay.h"

MTStatusBarOverlay *overlay;
UIButton *downloadButton;
UIButton *downloadsViewBtn;
UILabel *downloadLabel;
UIActionSheet *downloadSheet;
UIImage *downloadImg;
UIImage *downloadsImg;
UIImage *downloadImgPressed;
UINavigationController *navController;
UINavigationController *downloadsController;
WYPopoverController *fileDownloads;
NSMutableDictionary *videoLinks;
NSDictionary *parsedArray;
NSArray *paths;
NSString *basePath;
NSString *videoTitle;
NSString *imgURL;
NSString *currentVideoID;
NSString *downloadPath;
NSString *downloadLocation;
NSString *prefsPath = @"/private/var/mobile/Library/Preferences/com.freemanrepo.YouTuber.plist";
NSDictionary *prefsDict;
BOOL loadedImg = NO;
BOOL loadedDownloadsImg = NO;

@interface YTContentView
- (void)hideWatch;
@end

@interface YTTitleBar_iPad : UIView
- (void)setRightView:(id)fp8 animated:(BOOL)fp12;
- (void)setLeftView:(id)fp8;
@end

@interface YTOverflowMenuView : UIView <UIActionSheetDelegate, MTStatusBarOverlayDelegate>
- (void)showDownloadPrompt;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
-(void)downloadFromURL:(NSString *)vidURL toPath:(NSString *)videoPath;
- (void)viewDidDownloadAtPath:(NSString *)path;
@end

@implementation MAYouTuber
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)getVideoInfo
{
    [self parseVideoWithID:currentVideoID];
    [ProgressHUD showSuccess:nil];
}

+ (void)parseVideoWithID:(NSString *)vidID
{
    parsedArray = [[NSDictionary alloc] initWithDictionary:[HCYoutubeParser h264videosWithYoutubeID:vidID]];
    videoLinks = [[NSMutableDictionary alloc] init];
    if ([[parsedArray objectForKey:@"moreInfo"] objectForKey:@"iurl"])
        imgURL = [[parsedArray objectForKey:@"moreInfo"] objectForKey:@"iurl"];
    if ([[parsedArray objectForKey:@"moreInfo"] objectForKey:@"title"])
        videoTitle = [[parsedArray objectForKey:@"moreInfo"] objectForKey:@"title"];
    if ([parsedArray objectForKey:@"hd720"])
        [videoLinks setObject:[parsedArray objectForKey:@"hd720"] forKey:@"hd720"];
    if ([parsedArray objectForKey:@"medium"])
        [videoLinks setObject:[parsedArray objectForKey:@"medium"] forKey:@"medium"];
    if ([parsedArray objectForKey:@"small"])
        [videoLinks setObject:[parsedArray objectForKey:@"small"] forKey:@"small"];
}
@end

%hook YTWatchState
- (id)videoID
{
	currentVideoID = %orig;
	return %orig;
}
%end

%hook YTOverflowMenuView
- (void)layoutSubviews
{
    prefsDict = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
    if (![prefsDict objectForKey:@"downloaderEnabled"])
    {
        %orig;
    } else
    {
        if (!loadedImg)
            downloadImg = [UIImage imageWithContentsOfFile:@"/Library/Application Support/YouTuber/download.png"];
            downloadImgPressed = [UIImage imageWithContentsOfFile:@"/Library/Application Support/YouTuber/download_pressed.png"];
            loadedImg = YES;
            %orig;
        
        if ([(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
            [downloadButton removeFromSuperview];
            downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [downloadButton setBackgroundColor:[UIColor clearColor]];
            [downloadButton setImage:downloadImg forState:UIControlStateNormal];
            [downloadButton setImage:downloadImgPressed forState:UIControlStateSelected];
            [downloadButton setImage:downloadImgPressed forState:UIControlStateHighlighted];
            [downloadButton addTarget:self action:@selector(getVideoInfo) forControlEvents:UIControlEventTouchUpInside];
            downloadButton.frame = CGRectMake(MSHookIvar<UIButton*>(self, "_flagButton").frame.origin.x + 78, MSHookIvar<UIButton*>(self, "_flagButton").frame.origin.y, 45, 45);
            [self addSubview:downloadButton];
            
            [downloadLabel removeFromSuperview];
            downloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(downloadButton.frame.origin.x - 27, downloadButton.frame.origin.y + 38, 100, 50)];
            downloadLabel.backgroundColor = [UIColor clearColor];
            downloadLabel.textAlignment = UITextAlignmentCenter;
            downloadLabel.textColor=[UIColor whiteColor];
            downloadLabel.text = @"DOWNLOAD";
            [downloadLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:10]];
            [self addSubview:downloadLabel];
        } else
        {
            [downloadButton removeFromSuperview];
            downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [downloadButton setBackgroundColor:[UIColor clearColor]];
            [downloadButton setImage:downloadImg forState:UIControlStateNormal];
            [downloadButton setImage:downloadImgPressed forState:UIControlStateSelected];
            [downloadButton setImage:downloadImgPressed forState:UIControlStateHighlighted];
            [downloadButton addTarget:self action:@selector(getVideoInfo) forControlEvents:UIControlEventTouchUpInside];
            downloadButton.frame = CGRectMake(self.bounds.size.width - 50, self.bounds.size.height - 50, 45, 45);
            [self addSubview:downloadButton];
        }
    }
}

%new
- (void)showDownloadPrompt
{
    downloadSheet = [[UIActionSheet alloc] initWithTitle:videoTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"High Quality", @"Medium Quality", @"Low Quality", nil];
    [downloadSheet showInView:[[UIApplication sharedApplication] keyWindow].rootViewController.view];
}

%new
-(void)downloadFromURL:(NSString *)vidURL toPath:(NSString *)videoPath
{
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[basePath stringByAppendingPathComponent:@"YouTuber"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[basePath stringByAppendingPathComponent:@"YouTuber"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"hideBecauseCouldntFindABetterMethod"
     object:self];
    overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;
    overlay.detailViewMode = MTDetailViewModeDetailText;
    overlay.delegate = self;
    overlay.progress = 0.0;
    [overlay postMessage:@"Downloading Video" animated:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:vidURL]];
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:videoPath append:NO];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        overlay.progress = (float)totalBytesRead / totalBytesExpectedToRead;
    }];
    [operation setCompletionBlock:^{
        [overlay postFinishMessage:@"Download Complete" duration:2 animated:YES];
        downloadLocation = [basePath stringByAppendingPathComponent:@"YouTuber"];
        downloadPath = [[videoTitle stringByReplacingOccurrencesOfString:@"\"" withString:@"'"] stringByAppendingString:@".mov"];
        [self viewDidDownloadAtPath:[downloadLocation stringByAppendingPathComponent:downloadPath]];
    }];
    [operation start];
}

%new
- (void)viewDidDownloadAtPath:(NSString *)path
{
    navController = [[UINavigationController alloc] initWithRootViewController:[[VideoViewController alloc] initWithNibName:nil bundle:nil video:path]];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:navController animated:YES];
}

%new
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (videoTitle)
    {
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        NSLog(@"basePath: %@", basePath);
        downloadLocation = [basePath stringByAppendingPathComponent:@"YouTuber"];
        NSLog(@"downloadLocation: %@", downloadLocation);
        downloadPath = [[videoTitle stringByReplacingOccurrencesOfString:@"\"" withString:@"'"] stringByAppendingString:@".mov"];
        NSLog(@"downloadPath: %@", downloadPath);
        switch (buttonIndex)
        {
            case 0:
                if ([videoLinks objectForKey:@"hd720"])
                {
                    NSLog(@"Download hd720");
                    [self downloadFromURL:[videoLinks objectForKey:@"hd720"] toPath:[downloadLocation stringByAppendingPathComponent:downloadPath]];
                } else
                {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video resolution not available" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                }
                break;
            case 1:
                if ([videoLinks objectForKey:@"medium"])
                {
                    NSLog(@"Download medium");
                    [self downloadFromURL:[videoLinks objectForKey:@"medium"] toPath:[downloadLocation stringByAppendingPathComponent:downloadPath]];
                } else
                {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video resolution not available" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                }
                break;
            case 2:
                if ([videoLinks objectForKey:@"small"])
                {
                    NSLog(@"Download small");
                    [self downloadFromURL:[videoLinks objectForKey:@"small"] toPath:[downloadLocation stringByAppendingPathComponent:downloadPath]];
                } else
                {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video resolution not available" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                }
                break;
            default:
                break;
        }
    } else
    {
        NSLog(@"Video not ready");
    }
}


%new
- (void)getVideoInfo
{
    [ProgressHUD show:nil Interaction:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void)
    {
        [MAYouTuber getVideoInfo];
        NSLog(@"%@", videoTitle);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            [self showDownloadPrompt];
        }];
    });
}
%end

%hook YTContentView
%new
- (void)hideBecauseOfYouPwn:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"hideBecauseCouldntFindABetterMethod"])
    {
        [self hideWatch];
    }
}

- (void)layoutSubviews
{
    %orig;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBecauseOfYouPwn:)
                                                 name:@"hideBecauseCouldntFindABetterMethod"
                                               object:nil];
}
%end

%hook YTVASTAd
- (id)initWithStreamURL:(id)fp8 clickthroughURL:(id)fp12 impressionURLs:(id)fp16 startPingURLs:(id)fp20 firstQuartilePingURLs:(id)fp24 midpointPingURLs:(id)fp28 thirdQuartilePingURLs:(id)fp32 completePingURLs:(id)fp36 closePingURLs:(id)fp40 pausePingURLs:(id)fp44 resumePingURLs:(id)fp48 mutePingURLs:(id)fp52 fullscreenPingURLs:(id)fp56 skipShownPingURLs:(id)fp60 skipPingURLs:(id)fp64 progressPings:(id)fp68 videoTitleClickedPingURLs:(id)fp72 clickthroughPingURLs:(id)fp76 conversionPingURLs:(id)fp80 morePingURLs:(id)fp84 channelPingURLs:(id)fp88 watchLaterPingURLs:(id)fp92 shareAdPingURLs:(id)fp96 errorPingURLs:(id)fp100 adTagURL:(id)fp104 VATTURL:(id)fp108 adIDs:(id)fp112 adSystems:(id)fp116 fallbackAllowed:(BOOL)fp120 skippable:(BOOL)fp124 annotationsEnabled:(BOOL)fp128 adFrequencyCaps:(id)fp132 prefetchedAd:(id)fp136 adParameters:(id)fp140 infoCards:(id)fp144
{
    prefsDict = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
    if (![prefsDict objectForKey:@"adsBlockerEnabled"])
    {
        return %orig;
    }

}
%end

%hook YTReachability
- (BOOL)isOnWiFi
{
    prefsDict = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
    if (![prefsDict objectForKey:@"highQualityEnabled"])
    {
        return %orig;
    } else
    {
        return YES;
    }
}
%end

%hook YTPlayerViewController
- (BOOL)backgroundPlaybackAllowedForPlayerData:(id)fp8
{
    prefsDict = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
    if (![prefsDict objectForKey:@"playbackEnabled"])
    {
        return %orig;
    } else
    {
        return YES;
    }
}
%end

static void killYouTube(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo)
{
    system("killall YouTube");
}

%ctor
{
	%init();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, killYouTube, CFSTR("com.freemanrepo.YouTuber.settingsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}

/* unfinished
%hook YTTitleBar_iPad
- (void)layoutSubviews
{
}

- (void)setTitle:(id)fp8
{
    if ([fp8 isEqualToString:@"What to Watch"])
    {
        if (!loadedDownloadsImg)
            downloadsImg = [UIImage imageWithContentsOfFile:@"/Library/Application Support/YouTuber/downloads.png"];
            loadedDownloadsImg = YES;
            %orig;
        [downloadsViewBtn removeFromSuperview];
        downloadsViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 40, 40)];
        [downloadsViewBtn setImage:downloadsImg forState:UIControlStateNormal];
        [downloadsViewBtn addTarget:self action:@selector(showDownloads) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:downloadsViewBtn];
    }
    %orig;
}

%new
- (void)showDownloads
{
    downloadsController = [[UINavigationController alloc] initWithRootViewController:[YTDownloadsViewController alloc]];
    fileDownloads = [[WYPopoverController alloc] initWithContentViewController:downloadsController];
    
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
        [fileDownloads presentPopoverFromRect:downloadsViewBtn.frame
                                       inView:[[UIApplication sharedApplication] keyWindow].rootViewController.view
                     permittedArrowDirections:WYPopoverArrowDirectionUp
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
    } else
    {
        [fileDownloads presentPopoverFromRect:downloadsViewBtn.frame
                                       inView:[[UIApplication sharedApplication] keyWindow].rootViewController.view
                     permittedArrowDirections:WYPopoverArrowDirectionUp
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
    }
}
%end

%hook YTNavigation_iPhone
- (id)initWithServices:(id)fp8
{
    if ([MSHookIvar<UINavigationController*>(self, "_navigationController").title isEqualToString:@"What to Watch"])
    {
        if (!loadedDownloadsImg)
            downloadsImg = [UIImage imageWithContentsOfFile:@"/Library/Application Support/YouTuber/downloads.png"];
            loadedDownloadsImg = YES;
            %orig;
        [downloadsViewBtn removeFromSuperview];
        downloadsViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 40, 40)];
        [downloadsViewBtn setImage:downloadsImg forState:UIControlStateNormal];
        [downloadsViewBtn addTarget:self action:@selector(showDownloads) forControlEvents:UIControlEventTouchUpInside];
        [MSHookIvar<UINavigationController*>(self, "_navigationController").navigationBar addSubview:downloadsViewBtn];
    }
    %orig;
}

%new
- (void)showDownloads
{
    downloadsController = [[UINavigationController alloc] initWithRootViewController:[YTDownloadsViewController alloc]];
    fileDownloads = [[WYPopoverController alloc] initWithContentViewController:downloadsController];
    
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
        [fileDownloads presentPopoverFromRect:downloadsViewBtn.frame
                                       inView:[[UIApplication sharedApplication] keyWindow].rootViewController.view
                     permittedArrowDirections:WYPopoverArrowDirectionUp
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
    } else
    {
        [fileDownloads presentPopoverFromRect:downloadsViewBtn.frame
                                       inView:[[UIApplication sharedApplication] keyWindow].rootViewController.view
                     permittedArrowDirections:WYPopoverArrowDirectionUp
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
    }
}
%end