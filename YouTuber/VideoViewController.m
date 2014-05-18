//
//  VideoViewController.m
//  Misc Tests
//
//  Created by Majd Alfhaily on 5/14/14.
//  Copyright (c) 2014 Majd Alfhaily. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()
{
    NSString *videoPath;
    MPMoviePlayerController *moviePlayer;
}
@end

@implementation VideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil video:(NSString *)vid
{
    videoPath = vid;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"YouTuber"];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModalViewControllerAnimated:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Import" style:UIBarButtonItemStyleBordered target:self action:@selector(saveToCameraRoll)];
    }
    return self;
}

- (void)saveToCameraRoll
{
    
    NSURL *srcURL = [NSURL fileURLWithPath:videoPath];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            [self dismissModalViewControllerAnimated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video was not imported" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        } else {
            [self dismissModalViewControllerAnimated:YES];
            [[[UIAlertView alloc] initWithTitle:@"YouTuber" message:@"Video was imported" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        }
    };
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:srcURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:srcURL
                                    completionBlock:videoWriteCompletionBlock];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Import"])
    {
        [self saveToCameraRoll];
    } else if ([buttonTitle isEqualToString:@"Ignore"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [moviePlayer stop];
    [moviePlayer.view removeFromSuperview];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]];
    [moviePlayer prepareToPlay];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    [moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    [moviePlayer.view setFrame:self.view.bounds];
    [self.view addSubview:moviePlayer.view];
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
        [[[UIAlertView alloc] initWithTitle:@"YouTuber" message:@"Download Complete!\nWould you like to import the video to Camera Roll?" delegate:self cancelButtonTitle:@"Ignore" otherButtonTitles:@"Import", nil] show];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [moviePlayer stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
