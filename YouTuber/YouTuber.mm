#line 1 "/Users/Majd/Coding/YouTuber/YouTuber/YouTuber.xm"
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

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (void)getVideoInfo {
    [self parseVideoWithID:currentVideoID];
    [ProgressHUD showSuccess:nil];
}


+ (void)parseVideoWithID:(NSString *)vidID {
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

#include <logos/logos.h>
#include <substrate.h>
@class YTContentView; @class YTPlayerViewController; @class YTVASTAd; @class YTReachability; @class YTWatchState; @class YTOverflowMenuView; 
static id (*_logos_orig$_ungrouped$YTWatchState$videoID)(YTWatchState*, SEL); static id _logos_method$_ungrouped$YTWatchState$videoID(YTWatchState*, SEL); static void (*_logos_orig$_ungrouped$YTOverflowMenuView$layoutSubviews)(YTOverflowMenuView*, SEL); static void _logos_method$_ungrouped$YTOverflowMenuView$layoutSubviews(YTOverflowMenuView*, SEL); static void _logos_method$_ungrouped$YTOverflowMenuView$showDownloadPrompt(YTOverflowMenuView*, SEL); static void _logos_method$_ungrouped$YTOverflowMenuView$downloadFromURL$toPath$(YTOverflowMenuView*, SEL, NSString *, NSString *); static void _logos_method$_ungrouped$YTOverflowMenuView$viewDidDownloadAtPath$(YTOverflowMenuView*, SEL, NSString *); static void _logos_method$_ungrouped$YTOverflowMenuView$actionSheet$clickedButtonAtIndex$(YTOverflowMenuView*, SEL, UIActionSheet *, NSInteger); static void _logos_method$_ungrouped$YTOverflowMenuView$getVideoInfo(YTOverflowMenuView*, SEL); static void _logos_method$_ungrouped$YTContentView$hideBecauseOfYouPwn$(YTContentView*, SEL, NSNotification *); static void (*_logos_orig$_ungrouped$YTContentView$layoutSubviews)(YTContentView*, SEL); static void _logos_method$_ungrouped$YTContentView$layoutSubviews(YTContentView*, SEL); static id (*_logos_orig$_ungrouped$YTVASTAd$initWithStreamURL$clickthroughURL$impressionURLs$startPingURLs$firstQuartilePingURLs$midpointPingURLs$thirdQuartilePingURLs$completePingURLs$closePingURLs$pausePingURLs$resumePingURLs$mutePingURLs$fullscreenPingURLs$skipShownPingURLs$skipPingURLs$progressPings$videoTitleClickedPingURLs$clickthroughPingURLs$conversionPingURLs$morePingURLs$channelPingURLs$watchLaterPingURLs$shareAdPingURLs$errorPingURLs$adTagURL$VATTURL$adIDs$adSystems$fallbackAllowed$skippable$annotationsEnabled$adFrequencyCaps$prefetchedAd$adParameters$infoCards$)(YTVASTAd*, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, BOOL, BOOL, BOOL, id, id, id, id); static id _logos_method$_ungrouped$YTVASTAd$initWithStreamURL$clickthroughURL$impressionURLs$startPingURLs$firstQuartilePingURLs$midpointPingURLs$thirdQuartilePingURLs$completePingURLs$closePingURLs$pausePingURLs$resumePingURLs$mutePingURLs$fullscreenPingURLs$skipShownPingURLs$skipPingURLs$progressPings$videoTitleClickedPingURLs$clickthroughPingURLs$conversionPingURLs$morePingURLs$channelPingURLs$watchLaterPingURLs$shareAdPingURLs$errorPingURLs$adTagURL$VATTURL$adIDs$adSystems$fallbackAllowed$skippable$annotationsEnabled$adFrequencyCaps$prefetchedAd$adParameters$infoCards$(YTVASTAd*, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, BOOL, BOOL, BOOL, id, id, id, id); static BOOL (*_logos_orig$_ungrouped$YTReachability$isOnWiFi)(YTReachability*, SEL); static BOOL _logos_method$_ungrouped$YTReachability$isOnWiFi(YTReachability*, SEL); static BOOL (*_logos_orig$_ungrouped$YTPlayerViewController$backgroundPlaybackAllowedForPlayerData$)(YTPlayerViewController*, SEL, id); static BOOL _logos_method$_ungrouped$YTPlayerViewController$backgroundPlaybackAllowedForPlayerData$(YTPlayerViewController*, SEL, id); 

#line 85 "/Users/Majd/Coding/YouTuber/YouTuber/YouTuber.xm"


static id _logos_method$_ungrouped$YTWatchState$videoID(YTWatchState* self, SEL _cmd) {
	currentVideoID = _logos_orig$_ungrouped$YTWatchState$videoID(self, _cmd);
	return _logos_orig$_ungrouped$YTWatchState$videoID(self, _cmd);
}




static void _logos_method$_ungrouped$YTOverflowMenuView$layoutSubviews(YTOverflowMenuView* self, SEL _cmd) {
    prefsDict = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
    if (![prefsDict objectForKey:@"downloaderEnabled"])
    {
        _logos_orig$_ungrouped$YTOverflowMenuView$layoutSubviews(self, _cmd);
    } else
    {
        if (!loadedImg)
            downloadImg = [UIImage imageWithContentsOfFile:@"/Library/Application Support/YouTuber/download.png"];
            downloadImgPressed = [UIImage imageWithContentsOfFile:@"/Library/Application Support/YouTuber/download_pressed.png"];
            loadedImg = YES;
            _logos_orig$_ungrouped$YTOverflowMenuView$layoutSubviews(self, _cmd);
        
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



static void _logos_method$_ungrouped$YTOverflowMenuView$showDownloadPrompt(YTOverflowMenuView* self, SEL _cmd) {
    downloadSheet = [[UIActionSheet alloc] initWithTitle:videoTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"High Quality", @"Medium Quality", @"Low Quality", nil];
    [downloadSheet showInView:[[UIApplication sharedApplication] keyWindow].rootViewController.view];
}



static void _logos_method$_ungrouped$YTOverflowMenuView$downloadFromURL$toPath$(YTOverflowMenuView* self, SEL _cmd, NSString * vidURL, NSString * videoPath) {
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



static void _logos_method$_ungrouped$YTOverflowMenuView$viewDidDownloadAtPath$(YTOverflowMenuView* self, SEL _cmd, NSString * path) {
    navController = [[UINavigationController alloc] initWithRootViewController:[[VideoViewController alloc] initWithNibName:nil bundle:nil video:path]];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:navController animated:YES];
}



static void _logos_method$_ungrouped$YTOverflowMenuView$actionSheet$clickedButtonAtIndex$(YTOverflowMenuView* self, SEL _cmd, UIActionSheet * actionSheet, NSInteger buttonIndex) {
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




static void _logos_method$_ungrouped$YTOverflowMenuView$getVideoInfo(YTOverflowMenuView* self, SEL _cmd) {
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





static void _logos_method$_ungrouped$YTContentView$hideBecauseOfYouPwn$(YTContentView* self, SEL _cmd, NSNotification * notification) {
    if ([[notification name] isEqualToString:@"hideBecauseCouldntFindABetterMethod"])
    {
        [self hideWatch];
    }
}


static void _logos_method$_ungrouped$YTContentView$layoutSubviews(YTContentView* self, SEL _cmd) {
    _logos_orig$_ungrouped$YTContentView$layoutSubviews(self, _cmd);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBecauseOfYouPwn:)
                                                 name:@"hideBecauseCouldntFindABetterMethod"
                                               object:nil];
}




static id _logos_method$_ungrouped$YTVASTAd$initWithStreamURL$clickthroughURL$impressionURLs$startPingURLs$firstQuartilePingURLs$midpointPingURLs$thirdQuartilePingURLs$completePingURLs$closePingURLs$pausePingURLs$resumePingURLs$mutePingURLs$fullscreenPingURLs$skipShownPingURLs$skipPingURLs$progressPings$videoTitleClickedPingURLs$clickthroughPingURLs$conversionPingURLs$morePingURLs$channelPingURLs$watchLaterPingURLs$shareAdPingURLs$errorPingURLs$adTagURL$VATTURL$adIDs$adSystems$fallbackAllowed$skippable$annotationsEnabled$adFrequencyCaps$prefetchedAd$adParameters$infoCards$(YTVASTAd* self, SEL _cmd, id fp8, id fp12, id fp16, id fp20, id fp24, id fp28, id fp32, id fp36, id fp40, id fp44, id fp48, id fp52, id fp56, id fp60, id fp64, id fp68, id fp72, id fp76, id fp80, id fp84, id fp88, id fp92, id fp96, id fp100, id fp104, id fp108, id fp112, id fp116, BOOL fp120, BOOL fp124, BOOL fp128, id fp132, id fp136, id fp140, id fp144) {
    prefsDict = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
    if (![prefsDict objectForKey:@"adsBlockerEnabled"])
    {
        return _logos_orig$_ungrouped$YTVASTAd$initWithStreamURL$clickthroughURL$impressionURLs$startPingURLs$firstQuartilePingURLs$midpointPingURLs$thirdQuartilePingURLs$completePingURLs$closePingURLs$pausePingURLs$resumePingURLs$mutePingURLs$fullscreenPingURLs$skipShownPingURLs$skipPingURLs$progressPings$videoTitleClickedPingURLs$clickthroughPingURLs$conversionPingURLs$morePingURLs$channelPingURLs$watchLaterPingURLs$shareAdPingURLs$errorPingURLs$adTagURL$VATTURL$adIDs$adSystems$fallbackAllowed$skippable$annotationsEnabled$adFrequencyCaps$prefetchedAd$adParameters$infoCards$(self, _cmd, fp8, fp12, fp16, fp20, fp24, fp28, fp32, fp36, fp40, fp44, fp48, fp52, fp56, fp60, fp64, fp68, fp72, fp76, fp80, fp84, fp88, fp92, fp96, fp100, fp104, fp108, fp112, fp116, fp120, fp124, fp128, fp132, fp136, fp140, fp144);
    }

}




static BOOL _logos_method$_ungrouped$YTReachability$isOnWiFi(YTReachability* self, SEL _cmd) {
    prefsDict = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
    if (![prefsDict objectForKey:@"highQualityEnabled"])
    {
        return _logos_orig$_ungrouped$YTReachability$isOnWiFi(self, _cmd);
    } else
    {
        return YES;
    }
}




static BOOL _logos_method$_ungrouped$YTPlayerViewController$backgroundPlaybackAllowedForPlayerData$(YTPlayerViewController* self, SEL _cmd, id fp8) {
    prefsDict = [[NSDictionary alloc] initWithContentsOfFile:prefsPath];
    if (![prefsDict objectForKey:@"playbackEnabled"])
    {
        return _logos_orig$_ungrouped$YTPlayerViewController$backgroundPlaybackAllowedForPlayerData$(self, _cmd, fp8);
    } else
    {
        return YES;
    }
}


static void killYouTube(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo)
{
    system("killall YouTube");
}

static __attribute__((constructor)) void _logosLocalCtor_f2fc9902()
{
	{Class _logos_class$_ungrouped$YTWatchState = objc_getClass("YTWatchState"); MSHookMessageEx(_logos_class$_ungrouped$YTWatchState, @selector(videoID), (IMP)&_logos_method$_ungrouped$YTWatchState$videoID, (IMP*)&_logos_orig$_ungrouped$YTWatchState$videoID);Class _logos_class$_ungrouped$YTOverflowMenuView = objc_getClass("YTOverflowMenuView"); MSHookMessageEx(_logos_class$_ungrouped$YTOverflowMenuView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$YTOverflowMenuView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$YTOverflowMenuView$layoutSubviews);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTOverflowMenuView, @selector(showDownloadPrompt), (IMP)&_logos_method$_ungrouped$YTOverflowMenuView$showDownloadPrompt, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTOverflowMenuView, @selector(downloadFromURL:toPath:), (IMP)&_logos_method$_ungrouped$YTOverflowMenuView$downloadFromURL$toPath$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTOverflowMenuView, @selector(viewDidDownloadAtPath:), (IMP)&_logos_method$_ungrouped$YTOverflowMenuView$viewDidDownloadAtPath$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIActionSheet *), strlen(@encode(UIActionSheet *))); i += strlen(@encode(UIActionSheet *)); memcpy(_typeEncoding + i, @encode(NSInteger), strlen(@encode(NSInteger))); i += strlen(@encode(NSInteger)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTOverflowMenuView, @selector(actionSheet:clickedButtonAtIndex:), (IMP)&_logos_method$_ungrouped$YTOverflowMenuView$actionSheet$clickedButtonAtIndex$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTOverflowMenuView, @selector(getVideoInfo), (IMP)&_logos_method$_ungrouped$YTOverflowMenuView$getVideoInfo, _typeEncoding); }Class _logos_class$_ungrouped$YTContentView = objc_getClass("YTContentView"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSNotification *), strlen(@encode(NSNotification *))); i += strlen(@encode(NSNotification *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTContentView, @selector(hideBecauseOfYouPwn:), (IMP)&_logos_method$_ungrouped$YTContentView$hideBecauseOfYouPwn$, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$YTContentView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$YTContentView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$YTContentView$layoutSubviews);Class _logos_class$_ungrouped$YTVASTAd = objc_getClass("YTVASTAd"); MSHookMessageEx(_logos_class$_ungrouped$YTVASTAd, @selector(initWithStreamURL:clickthroughURL:impressionURLs:startPingURLs:firstQuartilePingURLs:midpointPingURLs:thirdQuartilePingURLs:completePingURLs:closePingURLs:pausePingURLs:resumePingURLs:mutePingURLs:fullscreenPingURLs:skipShownPingURLs:skipPingURLs:progressPings:videoTitleClickedPingURLs:clickthroughPingURLs:conversionPingURLs:morePingURLs:channelPingURLs:watchLaterPingURLs:shareAdPingURLs:errorPingURLs:adTagURL:VATTURL:adIDs:adSystems:fallbackAllowed:skippable:annotationsEnabled:adFrequencyCaps:prefetchedAd:adParameters:infoCards:), (IMP)&_logos_method$_ungrouped$YTVASTAd$initWithStreamURL$clickthroughURL$impressionURLs$startPingURLs$firstQuartilePingURLs$midpointPingURLs$thirdQuartilePingURLs$completePingURLs$closePingURLs$pausePingURLs$resumePingURLs$mutePingURLs$fullscreenPingURLs$skipShownPingURLs$skipPingURLs$progressPings$videoTitleClickedPingURLs$clickthroughPingURLs$conversionPingURLs$morePingURLs$channelPingURLs$watchLaterPingURLs$shareAdPingURLs$errorPingURLs$adTagURL$VATTURL$adIDs$adSystems$fallbackAllowed$skippable$annotationsEnabled$adFrequencyCaps$prefetchedAd$adParameters$infoCards$, (IMP*)&_logos_orig$_ungrouped$YTVASTAd$initWithStreamURL$clickthroughURL$impressionURLs$startPingURLs$firstQuartilePingURLs$midpointPingURLs$thirdQuartilePingURLs$completePingURLs$closePingURLs$pausePingURLs$resumePingURLs$mutePingURLs$fullscreenPingURLs$skipShownPingURLs$skipPingURLs$progressPings$videoTitleClickedPingURLs$clickthroughPingURLs$conversionPingURLs$morePingURLs$channelPingURLs$watchLaterPingURLs$shareAdPingURLs$errorPingURLs$adTagURL$VATTURL$adIDs$adSystems$fallbackAllowed$skippable$annotationsEnabled$adFrequencyCaps$prefetchedAd$adParameters$infoCards$);Class _logos_class$_ungrouped$YTReachability = objc_getClass("YTReachability"); MSHookMessageEx(_logos_class$_ungrouped$YTReachability, @selector(isOnWiFi), (IMP)&_logos_method$_ungrouped$YTReachability$isOnWiFi, (IMP*)&_logos_orig$_ungrouped$YTReachability$isOnWiFi);Class _logos_class$_ungrouped$YTPlayerViewController = objc_getClass("YTPlayerViewController"); MSHookMessageEx(_logos_class$_ungrouped$YTPlayerViewController, @selector(backgroundPlaybackAllowedForPlayerData:), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$backgroundPlaybackAllowedForPlayerData$, (IMP*)&_logos_orig$_ungrouped$YTPlayerViewController$backgroundPlaybackAllowedForPlayerData$);}
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, killYouTube, CFSTR("com.freemanrepo.YouTuber.settingsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}























































































