//
//  AppDelegate.h
//  QuartzCompositionPlayer
//
//  Created by Erik on 18.06.14.
//  Copyright (c) 2014 HTW Berlin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <WebKit/WebKit.h>
#import "CommandLineTool.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    QCView* qcView;
    WebView* webView;
    NSObjectController *objectController;
    CommandLineTool* _cmdLineTool;
    
}

@property(assign) IBOutlet NSWindow *window;
@property(retain) IBOutlet QCView *qcView;
@property(retain) IBOutlet WebView *webView;
@property(retain) IBOutlet NSObjectController *objectController;

@end
