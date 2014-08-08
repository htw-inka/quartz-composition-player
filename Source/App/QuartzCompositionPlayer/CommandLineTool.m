//
//  CommandLineTool.m
//  QuartzCompositionPlayer
//
//  Created by Erik on 16.07.14.
//  Copyright (c) 2014 HTW Berlin. All rights reserved.
//

#import "CommandLineTool.h"

@implementation CommandLineTool

NSString* const kCMDLN_TRIGGER_HELP                             = @"-help";
NSString* const kCMDLN_TRIGGER_SIZE                             = @"-window-size";
NSString* const kCMDLN_TRIGGER_ORIGIN                           = @"-window-origin";
NSString* const kCMDLN_TRIGGER_COMPOSITION                      = @"-composition";
NSString* const kCMDLN_TRIGGER_ARGS                             = @"-arguments";
NSString* const kCMDLN_SEPARATOR_ARG_KEY_VALUE                  = @"=";
NSString* const kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE      = @":";
NSString* const kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE    = @",";
NSString* const kCMDLN_ARG_LEDGRID                              = @"LED-Grid";
NSString* const kCMDLN_ARG_LEDCOMPLETE                          = @"LED-Complete";

NSString* const kCMDLN_TRIGGER_MEDIA_IMAGE                      = @"-image";
NSString* const kCMDLN_TRIGGER_MEDIA_VIDEO                      = @"-video";
NSString* const kCMDLN_TRIGGER_MEDIA_PRESENTATION               = @"-presentation";
NSString* const kCMDLN_TRIGGER_MEDIA_PATH                       = @"path";
NSString* const kCMDLN_TRIGGER_MEDIA_WIDTH                      = @"width";
NSString* const kCMDLN_TRIGGER_MEDIA_HEIGHT                     = @"height";
NSString* const kCMDLN_TRIGGER_MEDIA_LOOP                       = @"loop";
NSString* const kCMDLN_TRIGGER_MEDIA_START                      = @"start";
NSString* const kCMDLN_TRIGGER_MEDIA_DURATION                   = @"duration";
NSString* const kCMDLN_TRIGGER_MEDIA_RATE                       = @"rate";
NSString* const kCMDLN_TRIGGER_MEDIA_CONTROL                    = @"control";

NSString* const kQTZCOMP_PARAMKEY_MEDIATYPE                     = @"mediatype";
NSString* const kQTZCOMP_PARAMKEY_MEDIAPATH                     = @"mediapath";
NSString* const kQTZCOMP_PARAMKEY_MEDIAWIDTH                    = @"mediawidth";
NSString* const kQTZCOMP_PARAMKEY_MEDIAHEIGHT                   = @"mediaheight";
NSString* const kQTZCOMP_PARAMKEY_MEDIASTART                    = @"mediastart";
NSString* const kQTZCOMP_PARAMKEY_MEDIADURATION                 = @"mediaduration";
NSString* const kQTZCOMP_PARAMKEY_MEDIALOOPS                    = @"medialoops";
NSString* const kQTZCOMP_PARAMKEY_MEDIARATE                     = @"mediarate";
NSString* const kQTZCOMP_PARAMKEY_MEDIACONTROL                  = @"mediacontrol";

NSString* const kQTZCOMP_PARAMDEFAULT_VIDEOSTART                = @"0";
NSString* const kQTZCOMP_PARAMDEFAULT_VIDEODURATION             = @"0";
NSString* const kQTZCOMP_PARAMDEFAULT_VIDEOLOOPS                = @"0";
NSString* const kQTZCOMP_PARAMDEFAULT_VIDEORATE                 = @"1";
NSString* const kQTZCOMP_PARAMDEFAULT_PRESENTATIONDURATION      = @"3.0";
NSString* const kQTZCOMP_PARAMDEFAULT_PRESENTATIONLOOPS         = @"1";
NSString* const kQTZCOMP_PARAMDEFAULT_MEDIAWIDTH                = @"auto";
NSString* const kQTZCOMP_PARAMDEFAULT_MEDIAHEIGHT               = @"auto";
NSString* const kQTZCOMP_PARAMDEFAULT_MEDIACONTROL              = @"0";

const float kDEFAULT_WINDOW_WIDTH                       = 300;
const float kDEFAULT_WINDOW_HEIGHT                      = 100;
const float kDEFAULT_WINDOW_POS_X                       = 0;
const float kDEFAULT_WINDOW_POS_Y                       = 0;

const float kLEDGRID_WINDOW_WIDTH                       = 300;
const float kLEDGRID_WINDOW_HEIGHT                      = 100;
const float kLEDGRID_WINDOW_POS_X                       = 1962;
const float kLEDGRID_WINDOW_POS_Y                       = 784;

const float kLEDCOMPLETE_WINDOW_WIDTH                   = 504;
const float kLEDCOMPLETE_WINDOW_HEIGHT                  = 208;
const float kLEDCOMPLETE_WINDOW_POS_X                   = 1860;
const float kLEDCOMPLETE_WINDOW_POS_Y                   = 784;

@synthesize windowOrigin                  = _windowOrigin;
@synthesize windowSize                    = _windowSize;
@synthesize customQuartzCompositionPath   = _customQuartzCompositionPath;
@synthesize hasCustomQuartzComposition    = _hasCustomQuartzComposition;
@synthesize quartzArgumentsDictionary     = _quartzArgumentsDictionary;
@synthesize hasMediaSet                   = _hasMediaSet;


/*!
 This constructor needs an NSArray as an argument that holds the command line arguments that should be further processed.
 \param commandLineArguments The Array of command line arguments.
 \return The CommandLineTool object with the already processed command line arguments.
 */
- (id)initWithArguments:(NSArray *)commandLineArguments {
    
    if ((self = [super init]) && commandLineArguments != nil) {
        
        _windowOrigin                 = NSMakePoint(kDEFAULT_WINDOW_POS_X, kDEFAULT_WINDOW_POS_Y);
        _windowSize                   = NSMakeSize(kDEFAULT_WINDOW_WIDTH, kDEFAULT_WINDOW_HEIGHT);
        _customQuartzCompositionPath  = [[NSBundle mainBundle] pathForResource:@"QuartzCompositionPlayer" ofType:@"qtz"];
        _quartzArgumentsDictionary    = [NSMutableDictionary dictionary];
        _hasCustomQuartzComposition   = NO;
        
        _hasSizeSet     = NO;
        _hasOriginSet   = NO;
        _hasArgsSet     = NO;
        _hasMediaSet    = NO;
        
        [self processCmdLineArguments:commandLineArguments];
    }
    return self;
}

/*!
 This method will search for special trigger words inside the given array of strings with command line arguments. If some triggers are found the following arguments will be processed.
 \param commandLineArguments The NSArray containing the command line argument strings.
 */
- (void)processCmdLineArguments:(NSArray *)commandLineArguments {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    
    _commandLineArguments = commandLineArguments;
    
    for (NSString* arg in _commandLineArguments) {
            // -help was triggered.
        if ([arg hasPrefix: kCMDLN_TRIGGER_HELP] ) {
            NSString* help = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"README" ofType:@"txt"]
                                                       encoding: NSUTF8StringEncoding error: nil];
            NSLog(@"%@",help);
            exit(0);
        }
            // -window-size was triggered
        else if ([arg hasPrefix:kCMDLN_TRIGGER_SIZE]) {
            if (!_hasSizeSet) {
                _hasSizeSet = YES;
                NSString* tmp = [(NSArray*)[arg componentsSeparatedByString: kCMDLN_SEPARATOR_ARG_KEY_VALUE] lastObject];
                
                if ([tmp rangeOfString:kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE].location != NSNotFound) {
                    NSNumber* width  = [f numberFromString:(NSString*)[tmp substringToIndex:[tmp rangeOfString:kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE].location] ];
                    NSNumber* height = [f numberFromString:(NSString*)[tmp substringFromIndex:([tmp rangeOfString:kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE].location) + 1] ];
                    
                    if (width == nil || height == nil)  {
                        NSLog(@"[ERROR] Can't initialize window with size \"%@x%@\". Please use -help for a list of available command ¥line arguments.", width, height);
                        exit(1);
                    } else {
                        _windowSize.width   = [width floatValue];
                        _windowSize.height  = [height floatValue];
                    }
                } else if ([tmp isEqualToString: kCMDLN_ARG_LEDGRID]) {
                    _windowSize.width   = kLEDGRID_WINDOW_WIDTH;
                    _windowSize.height  = kLEDGRID_WINDOW_HEIGHT;
                } else if ([tmp isEqualToString: kCMDLN_ARG_LEDCOMPLETE]) {
                    _windowSize.width   = kLEDCOMPLETE_WINDOW_WIDTH;
                    _windowSize.height  = kLEDCOMPLETE_WINDOW_HEIGHT;
                } else {
                    
                    NSLog(@"[ERROR]: Can't initialize window with size \"%@\". Please use -help for a list of available command line arguments.", tmp);
                    exit(1);
                }
            }
        }
            // -window-origin was triggered
        else if ([arg hasPrefix:kCMDLN_TRIGGER_ORIGIN]) {
            if (!_hasOriginSet) {
                
                _hasOriginSet = YES;
                NSString* tmp = [(NSArray*)[arg componentsSeparatedByString: kCMDLN_SEPARATOR_ARG_KEY_VALUE] lastObject];
                
                if ([tmp rangeOfString:kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE].location != NSNotFound) {
                    NSNumber* x  = [f numberFromString:(NSString*)[tmp substringToIndex:[tmp rangeOfString:kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE].location] ];
                    NSNumber* y = [f numberFromString:(NSString*)[tmp substringFromIndex: ([tmp rangeOfString:kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE].location) + 1] ];
                    
                    if (x == nil || y == nil) {
                        NSLog(@"[ERROR]: Can't initialize window with origin \"%@x%@\". Please use -help for a list of available command line arguments.", x, y);
                        exit(1);
                    } else {
                        _windowOrigin.x = [x floatValue];
                        _windowOrigin.y = [y floatValue];
                    }
                } else if ([tmp isEqualToString: kCMDLN_ARG_LEDGRID]) {
                    _windowOrigin.x     = kLEDGRID_WINDOW_POS_X;
                    _windowOrigin.y     = kLEDGRID_WINDOW_POS_Y;
                } else if ([tmp isEqualToString: kCMDLN_ARG_LEDCOMPLETE]) {
                    _windowOrigin.x     = kLEDCOMPLETE_WINDOW_POS_X;
                    _windowOrigin.y     = kLEDCOMPLETE_WINDOW_POS_Y;
                } else {
                    NSLog(@"[ERROR]: Can't initialize window with origin \"%@\". Please use -help for a list of available command line arguments.", tmp);
                    exit(1);
                }
            }
        }
            // -composition was triggered
        else if ([arg hasPrefix: kCMDLN_TRIGGER_COMPOSITION]) {
            if (!_hasCustomQuartzComposition) {
                if (_hasMediaSet) {
                    NSLog(@"[WARNING] You already set the application to load a media type. \"%@\" will be ignored.", arg);
                } else if (_hasCustomQuartzComposition) {
                    NSLog(@"[WARNING] You already set the application to load a custom Quartz composition. \"%@\" will be ignored.", arg);
                } else {
                    _hasCustomQuartzComposition = YES;
                    [self processCustomQuartzCompositionFromArgument:arg];
                }
            }
        }
            // -arguments was triggereda
        else if ([arg hasPrefix: kCMDLN_TRIGGER_ARGS]) {
            if (!_hasArgsSet) {
                [self processCustomQuartzCompositionArgumentsFromArgument:arg];
            }
        }
            // -image was triggered
        else if ([arg hasPrefix: kCMDLN_TRIGGER_MEDIA_IMAGE]) {
            if (_hasMediaSet) {
                NSLog(@"[WARNING] You already set the application to load a media type. \"%@\" will be ignored.", arg);
            } else if (_hasCustomQuartzComposition) {
                NSLog(@"[WARNING] You already set the application to load a custom Quartz composition. \"%@\" will be ignored.", arg);
            } else {
                _hasMediaSet = YES;
                [self processImageFromArgument:arg];
            }
            
        }
            // -video was triggered
        else if ([arg hasPrefix:kCMDLN_TRIGGER_MEDIA_VIDEO]) {
            if (_hasMediaSet) {
                NSLog(@"[WARNING] You already set the application to load a media type. \"%@\" will be ignored.", arg);
            } else if (_hasCustomQuartzComposition) {
                NSLog(@"[WARNING] You already set the application to load a custom Quartz composition. \"%@\" will be ignored.", arg);
            } else {
                _hasMediaSet = YES;
                [self processVideoFromArgument:arg];
            }
        }
            // -presentation was triggered
        else if ([arg hasPrefix:kCMDLN_TRIGGER_MEDIA_PRESENTATION]) {
            if (_hasMediaSet) {
                NSLog(@"[WARNING] You already set the application to load a media type. \"%@\" will be ignored.", arg);
            } else if (_hasCustomQuartzComposition) {
                NSLog(@"[WARNING] You already set the application to load a custom Quartz composition. \"%@\" will be ignored.", arg);
            } else {
                _hasMediaSet = YES;
                [self processPresentationFromArgument:arg];
            }
        } else {
                // NSLog(@"[WARNING] Unknown argument \"%@\" will be ignored. Please use -help to see available command line arguments.", arg);
        }
    }
}

/*!
 This method will take the given NSString and try to extract a path to a custom Quartz composition file. If the path does either not exist or contain any other file type than Quartz composition the method will terminate the application.
 \param argument The string that contains the path .
 */
- (void)processCustomQuartzCompositionFromArgument:(NSString *)argument {
    
    NSString* path = [(NSArray*)[argument componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_KEY_VALUE]lastObject];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"[ERROR] Can't initialize window with composition from path \"%@\". File does not exist.", path);
        exit(1);
    } else if (![[path substringWithRange:NSMakeRange(path.length-3, 3)] isEqualToString:@"qtz"]) {
        NSLog(@"[ERROR] Can't initialize application of file type \"%@\". Has to be a Quartz Composition (*.qtz).", path);
        exit(1);
    }
    
    NSLog(@"[INFO] Loading Quartz Composition at path \"%@\".", path);
    _customQuartzCompositionPath = path;
}

/*!
 This method will try to extract the arguments that should be passed to the custom Quartz composition.
 If the passed argument string does not contain a closing "}" (because the command line will treat command line arguments containing a space as single arguments) the method will try to find that closing brackett in the following arguments. If none is found the method will exit the application. After that the method will separate the list of argements into a directory of arguments.
 \param argument The (first) argument that contains the Quartz composition arguments list.
 */
- (void)processCustomQuartzCompositionArgumentsFromArgument:(NSString *)argument {
    
    if (!_hasCustomQuartzComposition) {
        NSLog(@"[ERROR] Can't use your custom quartz composition arguments. You have not set any custom quartz composition path.");
        exit(1);
    }
    
    NSString* qtzArgsString = [(NSArray*)[argument componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_KEY_VALUE] lastObject];
    _hasArgsSet = YES;
    if ( ![qtzArgsString hasPrefix:@"{"]) {
        NSLog(@"[ERROR] Can't process your quartz composition arguments. No opening \"{\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    }
    
    long index = [_commandLineArguments indexOfObject:argument]+1;
    while (![qtzArgsString hasSuffix:@"}"] && index < _commandLineArguments.count) {
        qtzArgsString = [argument stringByAppendingString:[NSString stringWithFormat:@" %@",[_commandLineArguments objectAtIndex: index]] ];
        index++;
    }
    if (index >= _commandLineArguments.count) {        
        NSLog(@"[ERROR] Can't process your quartz composition arguments. No closing \"}\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\" to be accepted.");
        exit(1);
    } else {
        NSArray* qtzArgsArray = [(NSString*)[qtzArgsString substringWithRange:NSMakeRange(1, qtzArgsString.length-2)] componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE];
        if (qtzArgsArray.count <= 0) {
            NSLog(@"[ERROR] Can't process your quartz composition arguments. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
            exit(1);
        } else {
            for (NSString* qtzArg in qtzArgsArray) {
                NSArray* qtzArgArray = [qtzArg componentsSeparatedByString: kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE];
                Boolean separated = [qtzArgArray count] == 2;
                if (!separated) {
                    NSLog(@"[WARNING] Will ignore argument \"%@\" because its not a valid key:value pair.", qtzArg);
                } else {
                    NSLog(@"[INFO] Will pass argument \"%@\" to quartz composition.", qtzArg);
                    [_quartzArgumentsDictionary setValue: [qtzArgArray objectAtIndex:1] forKey: [qtzArgArray objectAtIndex:0]];
                }
            }
        }
    }
}

/*!
 This method will process the passed argument into a path to an image and additional parameters for that image. The image will be shown inside the Quartz composition.
 \param argument The argument that contains the image path and the additional parameters.
 */
- (void)processImageFromArgument:(NSString *)argument {
    
    NSString* argString = [[argument componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_KEY_VALUE] lastObject];
    
    if ( ![argString hasPrefix:@"{"]) {
        NSLog(@"[ERROR] Can't process your image arguments. No opening \"{\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    } else if ( ![argument hasSuffix:@"}"]) {
        NSLog(@"[ERROR] Can't process your image arguments. No opening \"}\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    } else {
        argString = [argString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    }
    
    NSArray* paramArray = [argString componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE];
    
    Boolean autoWidth   = YES;
    Boolean autoHeight  = YES;
    Boolean pathSet     = NO;
    
    for (NSString* param in paramArray) {
        if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_PATH]) {
            NSString* path = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                NSLog(@"[ERROR] Can't load image from path \"%@\". File does not exist.", path);
                exit(1);
            }
            NSLog(@"[INFO] Will load image from path \"%@\".", path);
            pathSet = YES;
            [_quartzArgumentsDictionary setValue:@"image" forKey:kQTZCOMP_PARAMKEY_MEDIATYPE];
            [_quartzArgumentsDictionary setValue:path forKey:kQTZCOMP_PARAMKEY_MEDIAPATH];
        }
        else if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_WIDTH]) {
            NSString* width = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ([width isEqualToString:@"auto"]) {
                NSLog(@"[INFO] Will display image with auto width.");
            } else if ([width isEqualToString:@"full"]) {
                NSLog(@"[INFO] Will display image with full width.");
                autoWidth = NO;
                [_quartzArgumentsDictionary setValue:[NSString stringWithFormat:@"%f", _windowSize.width]
                                              forKey:kQTZCOMP_PARAMKEY_MEDIAWIDTH];
            } else if ( (double)[width doubleValue] > 0) {
                NSLog(@"[INFO] Will display image with width \"%@\".", width);
                autoWidth = NO;
                [_quartzArgumentsDictionary setValue:width forKey:kQTZCOMP_PARAMKEY_MEDIAWIDTH];
            } else {
                NSLog(@"[WARNING] Your given image width of \"%@\" can't be used. Will use \"auto\" instead.", width);
            }
        }
        else if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_HEIGHT]) {
            NSString* height = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ([height isEqualToString:@"auto"]) {
                NSLog(@"[INFO] Will display image with auto height.");
            } else if ([height isEqualToString:@"full"]) {
                NSLog(@"[INFO] Will display image with full height.");
                autoHeight = NO;
                [_quartzArgumentsDictionary setValue:[NSString stringWithFormat:@"%f", _windowSize.height]
                                              forKey:kQTZCOMP_PARAMKEY_MEDIAHEIGHT];
            } else if ( (double)[height doubleValue] > 0) {
                NSLog(@"[INFO] Will display image with height \"%@\".", height);
                autoHeight = NO;
                [_quartzArgumentsDictionary setValue:height forKey:kQTZCOMP_PARAMKEY_MEDIAHEIGHT];
            } else {
                NSLog(@"[WARNING] Your given image height of \"%@\" can't be used. Will use \"auto\" instead.", height);
            }
        }
        
        if (!pathSet) {
            NSLog(@"[ERROR] You haven't set a path for the image.");
            exit(1);
        }
        
        if (autoHeight && autoWidth) {
            [_quartzArgumentsDictionary setValue:_windowSize.width >= _windowSize.height ? @"auto" : [NSString stringWithFormat:@"%f", _windowSize.width]
                                          forKey:kQTZCOMP_PARAMKEY_MEDIAWIDTH];
            [_quartzArgumentsDictionary setValue:_windowSize.width >= _windowSize.height ? [NSString stringWithFormat:@"%f", _windowSize.height] : @"auto"
                                          forKey:kQTZCOMP_PARAMKEY_MEDIAHEIGHT];
            
        }
    }
}

/*!
 This method will process the passed argument into a path to a video and additional parameters for that video. The video will be shown inside the Quartz composition.
 \param argument The argument that contains the video path and the additional parameters.
 */
- (void)processVideoFromArgument:(NSString *)argument {
    NSString* argString = [[argument componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_KEY_VALUE] lastObject];
    Boolean autoWidth   = YES;
    Boolean autoHeight  = YES;
    Boolean pathSet     = NO;
    
    if ( ![argString hasPrefix:@"{"]) {
        NSLog(@"[ERROR] Can't process your video arguments. No opening \"{\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    } else if ( ![argument hasSuffix:@"}"]) {
        NSLog(@"[ERROR] Can't process your video arguments. No opening \"}\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    } else {
        argString = [argString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    }
    
        // first set the passed QTZ argments to defaults
    [_quartzArgumentsDictionary setObject:kQTZCOMP_PARAMDEFAULT_VIDEODURATION
                                   forKey:kQTZCOMP_PARAMKEY_MEDIADURATION];
    [_quartzArgumentsDictionary setObject:kQTZCOMP_PARAMDEFAULT_VIDEOLOOPS
                                   forKey:kQTZCOMP_PARAMKEY_MEDIALOOPS];
    [_quartzArgumentsDictionary setObject:kQTZCOMP_PARAMDEFAULT_VIDEORATE
                                   forKey:kQTZCOMP_PARAMKEY_MEDIARATE];
    [_quartzArgumentsDictionary setObject:kQTZCOMP_PARAMDEFAULT_VIDEOSTART
                                   forKey:kQTZCOMP_PARAMKEY_MEDIASTART];
    
    NSArray* paramArray = [argString componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE];
    
    for (NSString* param in paramArray) {
        if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_PATH]) {
            NSString* path = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            
            if (![path hasSuffix:@".mov"]) {
                NSLog(@"[ERROR] Can't load video from path \"%@\". Only files inside a MOV (*.mov) container are supported.", path);
                exit(1);
            } else if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                NSLog(@"[ERROR] Can't load video from path \"%@\". File does not exist.", path);
                exit(1);
            }
            NSLog(@"[INFO] Will load video from path \"%@\".", path);
            pathSet = YES;
            [_quartzArgumentsDictionary setValue:@"video" forKey:kQTZCOMP_PARAMKEY_MEDIATYPE];
            [_quartzArgumentsDictionary setValue:path forKey:kQTZCOMP_PARAMKEY_MEDIAPATH];
        } else if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_WIDTH]) {
            NSString* width = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ([width isEqualToString:@"auto"]) {
                NSLog(@"[INFO] Will display image with auto width.");
            } else if ([width isEqualToString:@"full"]) {
                NSLog(@"[INFO] Will display image with full width.");
                autoWidth = NO;
                [_quartzArgumentsDictionary setValue:[NSString stringWithFormat:@"%f", _windowSize.width]
                                              forKey:kQTZCOMP_PARAMKEY_MEDIAWIDTH];
            } else if ( (double)[width doubleValue] > 0) {
                NSLog(@"[INFO] Will display image with width \"%@\".", width);
                autoWidth = NO;
                [_quartzArgumentsDictionary setValue:width forKey:kQTZCOMP_PARAMKEY_MEDIAWIDTH];
            } else {
                NSLog(@"[WARNING] Your given image width of \"%@\" can't be used. Will use \"auto\" instead.", width);
            }
        } else if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_HEIGHT]) {
            NSString* height = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ([height isEqualToString:@"auto"]) {
                NSLog(@"[INFO] Will display video with auto height.");
            } else if ([height isEqualToString:@"full"]) {
                NSLog(@"[INFO] Will display video with full height.");
                autoHeight = NO;
                [_quartzArgumentsDictionary setValue:[NSString stringWithFormat:@"%f", _windowSize.height]
                                              forKey:kQTZCOMP_PARAMKEY_MEDIAHEIGHT];
            } else if ( (double)[height doubleValue] > 0) {
                NSLog(@"[INFO] Will display video with height \"%@\".", height);
                autoHeight = NO;
                [_quartzArgumentsDictionary setValue:height forKey:kQTZCOMP_PARAMKEY_MEDIAHEIGHT];
            } else {
                NSLog(@"[WARNING] Your given video height of \"%@\" can't be used. Will use \"auto\" instead.", height);
            }
        } else if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_LOOP]) {
            NSString* loops = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ([loops intValue] <= 0) {
                NSLog(@"[INFO] You set a number of zero or less loops. Your video will loop infinitly.");
                [_quartzArgumentsDictionary setValue:kQTZCOMP_PARAMDEFAULT_VIDEOLOOPS forKey:kQTZCOMP_PARAMKEY_MEDIALOOPS];
            } else {
                NSLog(@"[INFO] Will set loops to %d.", [loops intValue]);
                [_quartzArgumentsDictionary setValue:[NSNumber numberWithInt:[loops intValue]] forKey:kQTZCOMP_PARAMKEY_MEDIALOOPS];
            }
        } else if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_RATE]) {
            NSString* rate = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ((NSInteger*)[rate integerValue] != nil) {
                NSLog(@"[INFO] Will use %@ as video rate.", rate);
                [_quartzArgumentsDictionary setValue:rate forKey:kQTZCOMP_PARAMKEY_MEDIARATE];
            } else {
                NSLog(@"[WARNING] Can't use \"%@\" as video rate. Will use %@ instead.",rate, kQTZCOMP_PARAMDEFAULT_VIDEORATE);
                [_quartzArgumentsDictionary setValue:kQTZCOMP_PARAMDEFAULT_VIDEORATE forKey:kQTZCOMP_PARAMKEY_MEDIARATE];
            }
            
        } else  if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_START ]) {
            NSString* start = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ([start floatValue] < 0) {
                NSLog(@"[WARNING] Your given video start time of \"%@\" can't be used. Will use %@ instead.", start, kQTZCOMP_PARAMDEFAULT_VIDEOSTART);
                [_quartzArgumentsDictionary setValue:kQTZCOMP_PARAMDEFAULT_VIDEOSTART forKey:kQTZCOMP_PARAMKEY_MEDIASTART];
            }
            else {
                NSLog(@"[INFO] Will start video at \"%@\" seconds.", start);
                [_quartzArgumentsDictionary setValue:start forKey:kQTZCOMP_PARAMKEY_MEDIASTART];
            }
        } else if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_DURATION]) {
            NSString* duration = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ((float)[duration floatValue] <= 0.0f) {
                NSLog(@"[WARNING] Your given video duration is less or equal to 0.0 therefore will be ignored.");
                [_quartzArgumentsDictionary setValue:kQTZCOMP_PARAMDEFAULT_VIDEODURATION forKey:kQTZCOMP_PARAMKEY_MEDIADURATION];
            } else {
                NSLog(@"[INFO] Will use %@ as video duration as long as it won't exeed the duration of full video.", duration);
                [_quartzArgumentsDictionary setValue:duration forKey:kQTZCOMP_PARAMKEY_MEDIADURATION];
            }
        }
        
        if (!pathSet) {
            NSLog(@"[ERROR] You haven't set a path for the video.");
            exit(1);
        }
        
        if (autoHeight && autoWidth) {
            [_quartzArgumentsDictionary setValue:_windowSize.width >= _windowSize.height ? @"auto" : [NSString stringWithFormat:@"%f", _windowSize.width]
                                          forKey:kQTZCOMP_PARAMKEY_MEDIAWIDTH];
            [_quartzArgumentsDictionary setValue:_windowSize.width >= _windowSize.height ? [NSString stringWithFormat:@"%f", _windowSize.height] : @"auto"
                                          forKey:kQTZCOMP_PARAMKEY_MEDIAHEIGHT];
            
        }
    }
}

/*!
 This method will process the passed argument into a path to a directory with images for a presentation and additional parameters for that presentation. The presentation will be shown inside the Quartz composition.
 \param argument The argument that contains the images' path and the additional parameters.
 */
- (void)processPresentationFromArgument:(NSString *)argument {
    NSString* argString = [[argument componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_KEY_VALUE] lastObject];
    
    Boolean pathSet = NO;
    
    if ( ![argString hasPrefix:@"{"]) {
        NSLog(@"[ERROR] Can't process your presentation arguments. No opening \"{\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    } else if ( ![argument hasSuffix:@"}"]) {
        NSLog(@"[ERROR] Can't process your presentation arguments. No opening \"}\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    } else {
        argString = [argString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    }
    
        // first set the QTZ arguments to their defaults.
    [_quartzArgumentsDictionary setObject:kQTZCOMP_PARAMDEFAULT_PRESENTATIONDURATION
                                   forKey:kQTZCOMP_PARAMKEY_MEDIADURATION];
    [_quartzArgumentsDictionary setObject:kQTZCOMP_PARAMDEFAULT_PRESENTATIONLOOPS
                                   forKey:kQTZCOMP_PARAMKEY_MEDIALOOPS];
    [_quartzArgumentsDictionary setObject:kQTZCOMP_PARAMDEFAULT_MEDIACONTROL
                                   forKey:kQTZCOMP_PARAMKEY_MEDIACONTROL];
    
    NSArray* paramArray = [argString componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE];
    
    for (NSString* param in paramArray) {
        
        if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_PATH]) {
            NSString* path = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                NSLog(@"[ERROR] Can't load directory from path \"%@\". Path does not exist.", path);
                exit(1);
            }
            NSLog(@"[INFO] Will load presentation images from path \"%@\".", path);
            pathSet = YES;
            [_quartzArgumentsDictionary setValue:@"presentation" forKey:kQTZCOMP_PARAMKEY_MEDIATYPE];
            [_quartzArgumentsDictionary setValue:path forKey:kQTZCOMP_PARAMKEY_MEDIAPATH];
        } else if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_LOOP]) {
            NSString* loops = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ([loops intValue] <= 0) {
                NSLog(@"[INFO] You set a number of zero or less loops. Your presentation will loop infinitly.");
                [_quartzArgumentsDictionary setValue:kQTZCOMP_PARAMDEFAULT_PRESENTATIONLOOPS forKey:kQTZCOMP_PARAMKEY_MEDIALOOPS];
            } else {
                NSLog(@"[INFO] Will set presentation loops to %d.", [loops intValue]);
                [_quartzArgumentsDictionary setValue:[NSNumber numberWithInt:[loops intValue]] forKey:kQTZCOMP_PARAMKEY_MEDIALOOPS];
            }
        } else if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_DURATION]) {
            NSString* duration = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ((float)[duration floatValue] <= 0.0f) {
                NSLog(@"[WARNING] Your given presentation duration is less than or equal to 0.0s therefore will be ignored and set to 3.0 seconds.");
                [_quartzArgumentsDictionary setValue:kQTZCOMP_PARAMDEFAULT_PRESENTATIONDURATION forKey:kQTZCOMP_PARAMKEY_MEDIADURATION];
            } else {
                NSLog(@"[INFO] Will use %@ as duration for each slide of your presentation.", duration);
                [_quartzArgumentsDictionary setValue:duration forKey:kQTZCOMP_PARAMKEY_MEDIADURATION];
            }
        } else if ([param hasPrefix:kCMDLN_TRIGGER_MEDIA_CONTROL]) {
            NSString* control = [[param componentsSeparatedByString:kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE] lastObject];
            if ([control isEqualToString:@"manual"]) {
                NSLog(@"[INFO] Will set presentation control mode to \"%@\".", control);
                [_quartzArgumentsDictionary setObject:[NSNumber numberWithBool:YES] forKey:kQTZCOMP_PARAMKEY_MEDIACONTROL];
            } else {
                NSLog(@"[INFO] Can't set presentation control mode to \"%@\". Will use \"auto\" instead.", control);
            }
        }
    }
    
    if (!pathSet) {
        NSLog(@"[ERROR] You haven't set a path for the presentation images.");
        exit(1);
    }
}

@end

