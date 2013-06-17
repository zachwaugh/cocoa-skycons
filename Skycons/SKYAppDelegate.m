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
  self.cloudyDay.type = SKYPartlyCloudyDay;
  self.cloudyNight.type = SKYPartlyCloudyNight;
  self.cloudy.type = SKYCloudy;
}

- (void)changeColor:(id)sender
{
  NSColor *color = [sender color];
  self.sun.color = color;
  self.moon.color = color;
  self.cloudyDay.color = color;
  self.cloudyNight.color = color;
  self.cloudy.color = color;
}

@end
