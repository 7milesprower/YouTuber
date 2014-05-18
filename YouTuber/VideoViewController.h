//
//  VideoViewController.h
//  Misc Tests
//
//  Created by Majd Alfhaily on 5/14/14.
//  Copyright (c) 2014 Majd Alfhaily. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoViewController : UIViewController <UIAlertViewDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil video:(NSString *)vid;
@end
