//
//  InstalledAppReader.h
//  YouTuber Preferences
//
//  Created by Majd Alfhaily on 5/18/14.
//
//

#import <Foundation/Foundation.h>

@interface InstalledAppReader : NSObject
-(NSArray *)installedApp;
-(NSMutableArray *)desktopAppsFromDictionary:(NSDictionary *)dictionary;
- (NSString *)getYouTubeVersion;
@end
