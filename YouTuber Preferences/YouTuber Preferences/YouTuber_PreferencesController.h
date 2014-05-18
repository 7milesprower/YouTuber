//
//  YouTuber_PreferencesController.h
//  YouTuber Preferences
//
//  Created by Majd Alfhaily on 5/17/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import "InstalledAppReader.h"

@interface YouTuber_PreferencesController : PSListController
{
}

- (id)getValueForSpecifier:(PSSpecifier*)specifier;
- (void)followOnTwitter:(PSSpecifier*)specifier;
- (void)makeDonation:(PSSpecifier*)specifier;

@end