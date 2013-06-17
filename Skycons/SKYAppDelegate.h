//
//  SKYAppDelegate.h
//  Skycons
//
//  Created by Zach Waugh on 6/17/13.
//  Copyright (c) 2013 Zach Waugh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SKYView;

@interface SKYAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet SKYView *sun;
@property (weak) IBOutlet SKYView *moon;
@property (weak) IBOutlet SKYView *cloudy;
@property (weak) IBOutlet SKYView *cloudyNight;

@end
