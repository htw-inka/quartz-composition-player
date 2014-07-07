//
//  AppDelegate.h
//  QuartzCompositionPlayer
//
//  Created by Erik on 18.06.14.
//  Copyright (c) 2014 HTW Berlin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#pragma constants

#define kCMDLN_HELP_TRIGGER @"-help"
#define kCMDLN_SIZE_TRIGGER @"-window-size"
#define kCMDLN_ORIGIN_TRIGGER @"-window-origin"
#define kCMDLN_PATH_TRIGGER @"-composition"
#define kCMDLN_ARGS_TRIGGER @"-arguments"
#define kCMDLN_ARG_VALUE_SEPERATOR @"="

#pragma end

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    QCView* qcView;
    NSObjectController *objectController;
    NSArray* cmdArguments;
}

@property(assign) IBOutlet NSWindow *window;
@property(retain) IBOutlet QCView *qcView;
@property(retain) IBOutlet NSObjectController *objectController;

@end
