//
//  AppDelegate.m
//  QuartzCompositionPlayer
//
//  Created by Erik on 18.06.14.
//  Copyright (c) 2014 HTW Berlin. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize qcView;
@synthesize webView;
@synthesize objectController;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // THIS IS THE PART WHERE WE PROCESS COMMAND LINE ARGUMENTS
    _cmdLineTool = [[CommandLineTool alloc] initWithArguments:[[NSProcessInfo processInfo] arguments]];
        
        
    if (_cmdLineTool.hasMediaSet || _cmdLineTool.hasCustomQuartzComposition) {
        // HERE WE PROGRAMATICALLY CREATE THE QCVIEW
        qcView = [[QCView alloc] initWithFrame:[self.window.contentView frame]];
        [self.window.contentView addSubview:qcView];
        
        //THIS IS FOR PROGRAMMATIC AUTO-LAYOUT...
        [qcView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *views = NSDictionaryOfVariableBindings(qcView);
        [self.window.contentView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[qcView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        [self.window.contentView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[qcView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        
        // NOW WE'RE LOADING THE QUARTZ COMPOSITION... CUSTOM OR STANDARD ONE DOESN'T MATTER
        [self loadComposition: _cmdLineTool.customQuartzCompositionPath];
        
        // PASSING THE LIST OF GIVEN ARGUMENTS TO THE CUSTOM QUARTZ COMPOSITION
        if (_cmdLineTool.hasCustomQuartzComposition || _cmdLineTool.hasMediaSet) {
            for (NSString* key in _cmdLineTool.quartzArgumentsDictionary) {
                [qcView setValue: [_cmdLineTool.quartzArgumentsDictionary valueForKey: key] forKeyPath: [NSString stringWithFormat:@"patch.%@.Value", key] ];
            }
        }
        
        [qcView startRendering];
    }
    
    else if (_cmdLineTool.hasWebsite) {
        // HERE WE PROGRAMATICALLY CREATE THE WEBVIEW
        webView = [[WebView alloc] initWithFrame:[self.window.contentView frame]];
        [self.window.contentView addSubview:webView];
        [webView setMainFrameURL:_cmdLineTool.websiteURL];
    }
    
    else {
        NSLog(@"[ERROR] Nothing to do here.");
        exit(0);
    }
        
    // NOW WE RESET THE SIZE AND POSITION OF THE WINDOW AND BRING IT TO THE FRONT; THE QUARTZVIEW WILL AUTOMATICALLY RESIZE
    [window setFrame:NSMakeRect(_cmdLineTool.windowOrigin.x, _cmdLineTool.windowOrigin.y, _cmdLineTool.windowSize.width, _cmdLineTool.windowSize.height) display:YES];
    [window orderFront: nil];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename{
	[self loadComposition:filename];
    return (filename != nil);
}

- (void) loadComposition:(NSString *)filename {
    QCComposition* qcComposition = [QCComposition compositionWithFile:filename];
    [qcView loadComposition:qcComposition];
    [qcView startRendering];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)theApplication
{
    return NO;
}

@end

