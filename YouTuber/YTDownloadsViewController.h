//
//  YTDownloadsViewController.h
//  YouTuber
//
//  Created by Majd Alfhaily on 5/16/14.
//
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface YTDownloadsViewController : UITableViewController <UIDocumentInteractionControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource>
{
    NSArray *filesArray;
    NSArray *baseOfDirectories;
    NSString *baseOfYouTube;
    UIDocumentInteractionController *docController;
}
@end
