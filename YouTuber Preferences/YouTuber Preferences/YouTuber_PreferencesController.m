//
//  YouTuber_PreferencesController.m
//  YouTuber Preferences
//
//  Created by Majd Alfhaily on 5/17/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "YouTuber_PreferencesController.h"
#import <Preferences/PSSpecifier.h>

#define YouTuberCurrentVersion @"YouTuberVersion"
#define YouTuberVersion @"1.0"
#define MaxSupportedYouTubeVersion @"2.6.0"

#define kUrl_MakeDonation @"http://freemanrepo.me/donate"
#define kUrl_MoreTweaks @"http://apt.thebigboss.org/packagesfordev.php?name=AnyDrop"

#define kPrefs_Path @"/var/mobile/Library/Preferences"
#define kPrefs_KeyName_Key @"key"
#define kPrefs_KeyName_Defaults @"defaults"

@implementation YouTuber_PreferencesController

- (id)getValueForSpecifier:(PSSpecifier*)specifier
{
	id value = nil;
	
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];
	
	// get 'value' with code only
	if ([specifierKey isEqual:YouTuberCurrentVersion])
	{
		value = YouTuberVersion;
	} else 	if ([specifierKey isEqual:@"YouTubeVersion"])
	{
		value = [[InstalledAppReader alloc] getYouTubeVersion];
	}

	// ...or get 'value' from 'defaults' plist or (optionally as a default value) with code
	else
	{
		// get 'value' from 'defaults' plist (if 'defaults' key and file exists)
		NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
		#if ! __has_feature(objc_arc)
		plistPath = [plistPath autorelease];
		#endif
		if (plistPath)
		{
			NSDictionary *dict = (NSDictionary*)[self initDictionaryWithFile:&plistPath asMutable:NO];
			
			id objectValue = [dict objectForKey:specifierKey];
			
			if (objectValue)
			{
				value = [NSString stringWithFormat:@"%@", objectValue];
				NSLog(@"read key '%@' with value '%@' from plist '%@'", specifierKey, value, plistPath);
			}
			else
			{
				NSLog(@"key '%@' not found in plist '%@'", specifierKey, plistPath);
			}
			
			#if ! __has_feature(objc_arc)
			[dict release];
			#endif
		}
	}
	
	return value;
}


- (id)initDictionaryWithFile:(NSMutableString**)plistPath asMutable:(BOOL)asMutable
{
	if ([*plistPath hasPrefix:@"/"])
		*plistPath = [NSString stringWithFormat:@"%@.plist", *plistPath];
	else
		*plistPath = [NSString stringWithFormat:@"%@/%@.plist", kPrefs_Path, *plistPath];
	
	Class class;
	if (asMutable)
		class = [NSMutableDictionary class];
	else
		class = [NSDictionary class];
	
	id dict;	
	if ([[NSFileManager defaultManager] fileExistsAtPath:*plistPath])
		dict = [[class alloc] initWithContentsOfFile:*plistPath];	
	else
		dict = [[class alloc] init];
	
	return dict;
}

- (void)followOnTwitter:(PSSpecifier*)specifier
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:@"freemanrepo"]]];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:@"freemanrepo"]]];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:@"freemanrepo"]]];
	}
}


- (void)makeDonation:(PSSpecifier *)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_MakeDonation]];
}

- (void)moreTweaks:(PSSpecifier *)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_MoreTweaks]];
}

- (id)specifiers
{
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"YouTuber_Preferences" target:self];
		#if ! __has_feature(objc_arc)
		[_specifiers retain];
		#endif
	}
	
	return _specifiers;
}

- (id)init
{
    if (![MaxSupportedYouTubeVersion compare:[[InstalledAppReader alloc] getYouTubeVersion] options:NSNumericSearch] == NSOrderedDescending) {
        if (![MaxSupportedYouTubeVersion isEqualToString:[[InstalledAppReader alloc] getYouTubeVersion]])
        {
            [[[UIAlertView alloc] initWithTitle:@"YouTuber" message:@"Looks like you're using an unsupported YouTube version :(\n\nYouTuber may not work as it should" delegate:self cancelButtonTitle:@"Ignore" otherButtonTitles:nil, nil] show];
        }
    }
	return self;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
	[super dealloc];
}
#endif

@end