//
//  SKYAppDelegate.m
//  Skycons
//
//  Created by Zach Waugh on 6/17/13.
//  Copyright (c) 2013 Zach Waugh. All rights reserved.
//

#import "SKYAppDelegate.h"
#import "SKYView.h"

@implementation SKYAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  self.sun.type = SKYClearDay;
  self.moon.type = SKYClearNight;
  self.cloudy.type = SKYPartlyCloudyDay;
  self.cloudyNight.type = SKYPartlyCloudyNight;
}

@end
