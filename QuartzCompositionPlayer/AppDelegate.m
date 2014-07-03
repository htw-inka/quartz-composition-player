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
    
    cmdArguments = [[NSProcessInfo processInfo] arguments];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    
    if (cmdArguments.count <= 3) {
        NSLog(@"[INFO] No program arguments given.\nStarting with default values (Size: 300x100, Origin: 0,0).\nUse -help to see available command line arguments.");
    }
    
    else {
        for (int i = 0; i< cmdArguments.count; i++){
            NSString* arg = [cmdArguments objectAtIndex:i];
            if ([arg isEqualToString:kCMDLN_HELP_TRIGGER] )
            {
                NSLog(@"[INFO] -composition <path>\t\t\t\t\t When set followed by a path the given composition will be loaded.");
                NSLog(@"[INFO] -arguments [key:value,key:value,...]\t When set a collection of key:value pairs separated by ',' surrounded by '[]' is expected containing the arguments that should be passed to the quartz composition.");
                NSLog(@"[INFO] -window-size [X,Y]\t\t\t\t\t When set followed by two numbers seperated by ',' the application will start with the given size. (Default: 300,100)");
                NSLog(@"[INFO] -window-origin [X,Y] \t\t\t\t\t When set followed by two numbers seperated by ',' the application will start at the given position. (Default: 0,0)");
                NSLog(@"[INFO] -help\t\t\t\t\t\t\t\t Shows this page (help).");
                exit(0);
            }            
            else if ([arg isEqualToString:kCMDLN_SIZE_TRIGGER])
            {
                if (!size_set)
                {
                    size_set = YES;
                    NSString* tmp = [cmdArguments objectAtIndex:i+1];
                    if ([tmp rangeOfString:@","].location != NSNotFound)
                    {
                        NSNumber* width  = [f numberFromString:(NSString*)[tmp substringToIndex:[tmp rangeOfString:@","].location] ];
                        NSNumber* height = [f numberFromString:(NSString*)[tmp substringFromIndex: ([tmp rangeOfString:@","].location) + 1] ];
                        if (width == nil || height == nil)
                        {
                            NSLog(@"[ERROR] Can't initialize window with size \"%@x%@\". Please use -help for a list of available command line arguments.", width, height);
                            exit(1);
                        }
                        else
                        {
                            window_size.width = [width floatValue];
                            window_size.height = [height floatValue];
                        }
                    }
                    i++;
                }
            }
            else if ([arg isEqualToString:kCMDLN_ORIGIN_TRIGGER])
            {
                if (!origin_set)
                {
                    size_set = YES;
                    NSString* tmp = [cmdArguments objectAtIndex:i+1];
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
                    i++;
                }
            }
            else if ([arg isEqualToString:kCMDLN_PATH_TRIGGER])
            {
                if (!path_set)
                {
                    path_set = YES;
                    NSString* custom_path = [cmdArguments objectAtIndex:i+1];
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
                    i++;
                }
            }
            else if ([arg isEqualToString:kCMDLN_ARGS_TRIGGER])
            {
                if (!args_set)
                {
                    NSString* qtzArgsString = [cmdArguments objectAtIndex:i+1];
                    if (!path_set)
                    {
                        NSLog(@"[ERROR] Can't use \"%@\" as quartz composition arguments. You have not set any custom quartz composition to be loaded.", qtzArgsString);
                        exit(1);
                    }
                    
                    args_set = YES;                    
                    Boolean format = [qtzArgsString hasPrefix:@"["] && [qtzArgsString hasSuffix:@"]"];
                    
                    if (!format)
                    {
                        NSLog(@"[ERROR] Can't use \"%@\" as quartz composition arguments. Arguments have to be without any spaces surrounded by \"[ ]\" and separated by \",\"to be accepted.", qtzArgsString);
                        exit(1);
                    }
                    else
                    {
                        NSArray* qtzArgsArray = [(NSString*)[qtzArgsString substringWithRange:NSMakeRange(1, qtzArgsString.length-2)] componentsSeparatedByString:@","];
                        if (qtzArgsArray.count <= 0)
                        {
                            NSLog(@"[ERROR] Can't use \"%@\" as quartz composition arguments. Arguments have to be without any spaces surrounded by \"[ ]\" and separated by \",\"to be accepted.", qtzArgsString);
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
                    i++;
                }
            }
            else
            {
                NSLog(@"WARNING: Unknown argument \"%@\" will be ignored. Please use -help to see available command line arguments.", arg);
            }
            
        }
    }
    
    [window setFrame:NSMakeRect(window_origin.x, window_origin.y, window_size.width, window_size.height) display:YES];
    
    [self loadComposition: path];
    
    for (NSString* key in qtzArgsDictionary) {
        [objectController setValue: [qtzArgsDictionary valueForKey: key] forKeyPath: [NSString stringWithFormat:@"selection.patch.%@.Value", key] ];
    }
    
    [qcView setFrame:NSMakeRect(0, 0, window_size.width, window_size.height)];
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

