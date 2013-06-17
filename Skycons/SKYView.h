//
//  SKYView.h
//  Skycons
//
//  Created by Zach Waugh on 6/17/13.
//  Copyright (c) 2013 Zach Waugh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, SKYIconType) {
  SKYClearDay,
  SKYClearNight,
  SKYPartlyCloudyDay,
  SKYPartlyCloudyNight,
  SKYCloudy,
  SKYRain,
  SKYSleet,
  SKYSnow,
  SKYWind,
  SKYFog
};

@interface SKYView : NSView

@property (strong, nonatomic) NSColor *color;
@property (assign, nonatomic) SKYIconType type;

- (void)play;
- (void)pause;

@end
