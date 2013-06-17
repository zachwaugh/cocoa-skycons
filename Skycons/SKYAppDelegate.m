//
//  SKYAppDelegate.m
//  Skycons
//
//  Created by Zach Waugh on 6/17/13.
//  Copyright (c) 2013 Zach Waugh. All rights reserved.
//

#import "SKYAppDelegate.h"
#import "SKYIconView.h"

#define ICON_SIZE 128
#define PADDING 20

@interface SKYAppDelegate ()

@property (strong) NSMutableArray *icons;

@end

@implementation SKYAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  self.icons = [[NSMutableArray alloc] init];
  NSArray *types = @[@(SKYClearDay), @(SKYClearNight), @(SKYPartlyCloudyDay), @(SKYPartlyCloudyNight), @(SKYCloudy), @(SKYRain), @(SKYSleet), @(SKYSnow), @(SKYWind), @(SKYFog)];
  
  NSView *container = self.backgroundView;
  NSRect frame = NSMakeRect(PADDING, PADDING, ICON_SIZE, ICON_SIZE);
  
  for (int i = 0; i < types.count; i++) {
    SKYIconType type = [types[i] integerValue];
    SKYIconView *icon = [[SKYIconView alloc] initWithFrame:frame];
    icon.type = type;
    [container addSubview:icon];
    [self.icons addObject:icon];
    
    frame.origin.x += ICON_SIZE + PADDING;
    
    if (frame.origin.x >= container.frame.size.width) {
      frame.origin.y += ICON_SIZE + PADDING;
      frame.origin.x = PADDING;
    }
  }
}

- (void)changeColor:(id)sender
{
  NSColor *color = [sender color];
 
  for (SKYIconView *icon in self.icons) {
    icon.color = color;
  }
}

@end
