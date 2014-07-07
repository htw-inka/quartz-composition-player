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
@synthesize objectController;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSPoint window_origin = NSMakePoint(0, 0);
    NSSize window_size = NSMakeSize(300, 100);
    NSString* path = [[NSBundle mainBundle] pathForResource:@"QuartzCompositionPlayer" ofType:@"qtz"];
    Boolean size_set = NO;
    Boolean origin_set = NO;
    Boolean path_set = NO;
    Boolean args_set = NO;
    
    NSMutableDictionary* qtzArgsDictionary = [NSMutableDictionary dictionary];
    
    
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
    
    // THIS IS THE PART WHERE WE PROCESS COMMAND LINE ARGUMENTS
    cmdArguments = [[NSProcessInfo processInfo] arguments];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    
    if (cmdArguments.count <= 3) {
        NSLog(@"[INFO] No program arguments given.\nStarting with default values (Size: 300x100, Origin: 0,0).\nUse -help to see available command line arguments.");
    }
    
    else {
        for (NSString* arg in cmdArguments){
            if ([arg hasPrefix: kCMDLN_HELP_TRIGGER] )
            {
                NSString* help = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"README" ofType:@"txt"]
                                                           encoding: NSUTF8StringEncoding error: nil];
                NSLog(@"%@",help);
                exit(0);
            }            
            else if ([arg hasPrefix:kCMDLN_SIZE_TRIGGER])
            {
                if (!size_set)
                {
                    size_set = YES;
                    NSString* tmp = [(NSArray*)[arg componentsSeparatedByString: kCMDLN_ARG_VALUE_SEPERATOR] lastObject];
                    if ([tmp rangeOfString:@","].location != NSNotFound)
                    {
                        NSNumber* width  = [f numberFromString:(NSString*)[tmp substringToIndex:[tmp rangeOfString:@","].location] ];
                        NSNumber* height = [f numberFromString:(NSString*)[tmp substringFromIndex: ([tmp rangeOfString:@","].location) + 1] ];
                        if (width == nil || height == nil)
                        {
                            NSLog(@"[ERROR] Can't initialize window with size \"%@x%@\". Please use -help for a list of available command ¥line arguments.", width, height);
                            exit(1);
                        }
                        else
                        {
                            window_size.width = [width floatValue];
                            window_size.height = [height floatValue];
                        }
                    }
                }
            }
            else if ([arg hasPrefix:kCMDLN_ORIGIN_TRIGGER])
            {
                if (!origin_set)
                {
                    origin_set = YES;
                    NSString* tmp = [(NSArray*)[arg componentsSeparatedByString: kCMDLN_ARG_VALUE_SEPERATOR] lastObject];
                    if ([tmp rangeOfString:@","].location != NSNotFound)
                    {
                        NSNumber* x  = [f numberFromString:(NSString*)[tmp substringToIndex:[tmp rangeOfString:@","].location] ];
                        NSNumber* y = [f numberFromString:(NSString*)[tmp substringFromIndex: ([tmp rangeOfString:@","].location) + 1] ];
                        if (x == nil || y == nil)
                        {
                            NSLog(@"[ERROR]: Can't initialize window with origin \"%@x%@\". Please use -help for a list of available command line arguments.", x, y);
                            exit(1);
                        }
                        else
                        {
                            window_origin.x = [x floatValue];
                            window_origin.y = [y floatValue];
                        }
                    }
                }
            }
            else if ([arg hasPrefix: kCMDLN_PATH_TRIGGER])
            {
                if (!path_set)
                {
                    path_set = YES;
                    NSString* custom_path = [(NSArray*)[arg componentsSeparatedByString:kCMDLN_ARG_VALUE_SEPERATOR]lastObject];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:custom_path])
                    {
                        NSLog(@"[ERROR] Can't initialize window with composition from path \"%@\". File does not exist.", custom_path);
                        exit(1);
                    }
                    
                    else if (![[custom_path substringWithRange:NSMakeRange(custom_path.length-3, 3)] isEqualToString:@"qtz"])
                    {
                        NSLog(@"[ERROR] Can't initialize application of file type \"%@\". Has to be a Quartz Composition (*.qtz).", custom_path);
                        exit(1);
                    }                    
                    
                    NSLog(@"[INFO] Loading Quartz Composition at path \"%@\".", custom_path);
                    path = custom_path;
                }
            }
            else if ([arg hasPrefix: kCMDLN_ARGS_TRIGGER])
            {
                if (!args_set)
                {
                    NSString* qtzArgsString = [(NSArray*)[arg componentsSeparatedByString:kCMDLN_ARG_VALUE_SEPERATOR] lastObject];
                    
                    if (!path_set)
                    {
                        NSLog(@"[ERROR] Can't use your custom quartz composition arguments. You have not set any custom quartz composition path.");
                        exit(1);
                    }
                    
                    args_set = YES;                    
                    if ( ![qtzArgsString hasPrefix:@"{"]) {
                        NSLog(@"[ERROR] Can't process your quartz composition arguments. No opening \"{\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
                        exit(1);
                    }
                    
                    long index = [cmdArguments indexOfObject:arg]+1;
                    while (![qtzArgsString hasSuffix:@"}"] && index < cmdArguments.count) {
                        qtzArgsString = [qtzArgsString stringByAppendingString:[NSString stringWithFormat:@" %@",[cmdArguments objectAtIndex: index]] ];
                        index++;
                    }
                    if (index >= cmdArguments.count) {
                        NSLog(@"[ERROR] Can't process your quartz composition arguments. No closing \"}\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
                        exit(1);
                        
                    } else {
                        NSArray* qtzArgsArray = [(NSString*)[qtzArgsString substringWithRange:NSMakeRange(1, qtzArgsString.length-2)] componentsSeparatedByString:@","];
                        if (qtzArgsArray.count <= 0)
                        {
                            NSLog(@"[ERROR] Can't process your quartz composition arguments. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
                            exit(1);
                        }
                        else
                        {
                            for (NSString* qtzArg in qtzArgsArray)
                            {
                                NSArray* qtzArgArray = [qtzArg componentsSeparatedByString: @":"];
                                Boolean separated = [qtzArgArray count] == 2;
                                if (!separated)
                                {
                                    NSLog(@"[WARNING] Will ignore argument \"%@\" because its not a valid key:value pair.", qtzArg);
                                }
                                else
                                {
                                    NSLog(@"[INFO] Will pass argument \"%@\" to quartz composition.", qtzArg);
                                    [qtzArgsDictionary setValue: [qtzArgArray objectAtIndex:1] forKey: [qtzArgArray objectAtIndex:0]];
                                }
                            }
                                
                        }
                    }
                }
            }
            else
            {
                // NSLog(@"[WARNING] Unknown argument \"%@\" will be ignored. Please use -help to see available command line arguments.", arg);
            }
            
        }
    }
    
    // NOW WE RESET THE SIZE OF THE WINDOW; THE QUARTZVIEW WILL AUTOMATICALLY RESIZE
    [window setFrame:NSMakeRect(window_origin.x, window_origin.y, window_size.width, window_size.height) display:YES];
    
    // NOW WE'RE LOADING THE QUARTZ COMPOSITION... CUSTOM OR STANDARD ONE DOESN'T MATTER
    [self loadComposition: path];
    
    // PASSING THE LIST OF GIVEN ARGUMENTS TO THE CUSTOM QUARTZ COMPOSITION
    if (path_set) {
        for (NSString* key in qtzArgsDictionary) {
            [qcView setValue: [qtzArgsDictionary valueForKey: key] forKeyPath: [NSString stringWithFormat:@"patch.%@.Value", key] ];
        }
    }

    [qcView startRendering];
    
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

