//
//  SKYAppDelegate.h
//  Skycons
//
//  Created by Zach Waugh on 6/17/13.
//  Copyright (c) 2013 Zach Waugh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SKYIconView;

@interface SKYAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *backgroundView;

- (IBAction)changeColor:(id)sender;

@end
