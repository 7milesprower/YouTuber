//
//  InstalledAppReader.m
//  YouTuber Preferences
//
//  Created by Majd Alfhaily on 5/18/14.
//
//

#import "InstalledAppReader.h"

static NSString* const installedAppListPath = @"/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist";

@implementation InstalledAppReader

-(NSMutableArray *)desktopAppsFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *desktopApps = [NSMutableArray array];
    
    for (NSString *appKey in dictionary)
    {
        [desktopApps addObject:appKey];
    }
    return desktopApps;
}

- (BOOL)isYouTubeInstalled
{
    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath: installedAppListPath isDirectory: &isDir] && !isDir)
    {
        NSMutableDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile: installedAppListPath];
        NSDictionary *user = [cacheDict objectForKey: @"User"];
        NSMutableArray *installedApp = [NSMutableArray arrayWithArray:[self desktopAppsFromDictionary:user]];
        
        if ([installedApp containsObject:@"com.google.ios.youtube"])
        {
            return YES;
        } else
        {
            return NO;
        }
    } else
    {
        return NO;
    }
}

- (NSString *)getYouTubeVersion
{
    if ([self isYouTubeInstalled])
    {
        BOOL isDir = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath: installedAppListPath isDirectory: &isDir] && !isDir)
        {
            NSMutableDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile: installedAppListPath];
            NSDictionary *user = [cacheDict objectForKey: @"User"];
            NSString *ytVersion = [[user objectForKey:@"com.google.ios.youtube"] objectForKey:@"CFBundleShortVersionString"];
            return ytVersion;
        } else
        {
            return @"YouTube not installed";
        }
    } else
    {
        return @"YouTube not installed";
    }
}
@end
