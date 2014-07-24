//
//  CommandLineTool.m
//  QuartzCompositionPlayer
//
//  Created by Erik on 16.07.14.
//  Copyright (c) 2014 HTW Berlin. All rights reserved.
//

#import "CommandLineTool.h"

@implementation CommandLineTool

NSString* const kCMDLN_HELP_TRIGGER                     = @"-help";
NSString* const kCMDLN_SIZE_TRIGGER                     = @"-window-size";
NSString* const kCMDLN_ORIGIN_TRIGGER                   = @"-window-origin";
NSString* const kCMDLN_COMPOSITION_TRIGGER              = @"-composition";
NSString* const kCMDLN_ARGS_TRIGGER                     = @"-arguments";
NSString* const kCMDLN_ARG_KEY_VALUE_SEPARATOR          = @"=";
NSString* const kCMDLN_ARG_LEDGRID                      = @"LED-Grid";
NSString* const kCMDLN_ARG_LEDCOMPLETE                  = @"LED-Complete";
NSString* const kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR    = @":";
NSString* const kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR  = @",";

NSString* const kCMDLN_MEDIA_IMAGE_TRIGGER              = @"-image";
NSString* const kCMDLN_MEDIA_VIDEO_TRIGGER              = @"-video";
NSString* const kCMDLN_MEDIA_PRESENTATION_TRIGGER       = @"-presentation";
NSString* const kCMDLN_MEDIA_PATH_TRIGGER               = @"path";
NSString* const kCMDLN_MEDIA_WIDTH_TRIGGER              = @"width";
NSString* const kCMDLN_MEDIA_HEIGHT_TRIGGER             = @"height";
NSString* const kCMDLN_MEDIA_LOOP_TRIGGER               = @"loop";
NSString* const kCMDLN_MEDIA_START_TRIGGER              = @"start";
NSString* const kCMDLN_MEDIA_DURATION_TRIGGER           = @"duration";
NSString* const kCMDLN_MEDIA_RATE_TRIGGER               = @"rate";

NSString* const kQTZ_COMP_MEDIATYPE_PARAM_KEY           = @"mediatype";
NSString* const kQTZ_COMP_MEDIAPATH_PARAM_KEY           = @"mediapath";
NSString* const kQTZ_COMP_MEDIAWIDTH_PARAM_KEY          = @"mediawidth";
NSString* const kQTZ_COMP_MEDIAHEIGHT_PARAM_KEY         = @"mediaheight";
NSString* const kQTZ_COMP_MEDIASTART_PARAM_KEY          = @"mediastart";
NSString* const kQTZ_COMP_MEDIADURATION_PARAM_KEY       = @"mediaduration";
NSString* const kQTZ_COMP_MEDIALOOPS_PARAM_KEY          = @"medialoops";
NSString* const kQTZ_COMP_MEDIARATE_PARAM_KEY           = @"mediarate";

NSString* const kQTZ_COMP_DEFAULT_MEDIASTART            = @"0";
NSString* const kQTZ_COMP_DEFAULT_MEDIADURATION         = @"0";
NSString* const kQTZ_COMP_DEFAULT_MEDIALOOPS            = @"0";
NSString* const kQTZ_COMP_DEFAULT_MEDIARATE             = @"1";

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
        if ([arg hasPrefix: kCMDLN_HELP_TRIGGER] ) {
            NSString* help = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"README" ofType:@"txt"]
                                                       encoding: NSUTF8StringEncoding error: nil];
            NSLog(@"%@",help);
            exit(0);
        }
            // -window-size was triggered
        else if ([arg hasPrefix:kCMDLN_SIZE_TRIGGER]) {
            if (!_hasSizeSet) {
                _hasSizeSet = YES;
                NSString* tmp = [(NSArray*)[arg componentsSeparatedByString: kCMDLN_ARG_KEY_VALUE_SEPARATOR] lastObject];
                
                if ([tmp rangeOfString:kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR].location != NSNotFound) {
                    NSNumber* width  = [f numberFromString:(NSString*)[tmp substringToIndex:[tmp rangeOfString:kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR].location] ];
                    NSNumber* height = [f numberFromString:(NSString*)[tmp substringFromIndex:([tmp rangeOfString:kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR].location) + 1] ];
                    
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
        else if ([arg hasPrefix:kCMDLN_ORIGIN_TRIGGER]) {
            if (!_hasOriginSet) {
                
                _hasOriginSet = YES;
                NSString* tmp = [(NSArray*)[arg componentsSeparatedByString: kCMDLN_ARG_KEY_VALUE_SEPARATOR] lastObject];
                
                if ([tmp rangeOfString:kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR].location != NSNotFound) {
                    NSNumber* x  = [f numberFromString:(NSString*)[tmp substringToIndex:[tmp rangeOfString:kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR].location] ];
                    NSNumber* y = [f numberFromString:(NSString*)[tmp substringFromIndex: ([tmp rangeOfString:kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR].location) + 1] ];
                    
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
        else if ([arg hasPrefix: kCMDLN_COMPOSITION_TRIGGER]) {
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
        else if ([arg hasPrefix: kCMDLN_ARGS_TRIGGER]) {
            if (!_hasArgsSet) {
                [self processCustomQuartzCompositionArgumentsFromArgument:arg];
            }
        }
            // -image was triggered
        else if ([arg hasPrefix: kCMDLN_MEDIA_IMAGE_TRIGGER]) {
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
        else if ([arg hasPrefix:kCMDLN_MEDIA_VIDEO_TRIGGER]) {
            if (_hasMediaSet) {
                NSLog(@"[WARNING] You already set the application to load a media type. \"%@\" will be ignored.", arg);
            } else if (_hasCustomQuartzComposition) {
                NSLog(@"[WARNING] You already set the application to load a custom Quartz composition. \"%@\" will be ignored.", arg);
            } else {
                _hasMediaSet = YES;
                [self processVideoFromArgument:arg];
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
    
    NSString* path = [(NSArray*)[argument componentsSeparatedByString:kCMDLN_ARG_KEY_VALUE_SEPARATOR]lastObject];
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
    
    NSString* qtzArgsString = [(NSArray*)[argument componentsSeparatedByString:kCMDLN_ARG_KEY_VALUE_SEPARATOR] lastObject];
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
        NSArray* qtzArgsArray = [(NSString*)[qtzArgsString substringWithRange:NSMakeRange(1, qtzArgsString.length-2)] componentsSeparatedByString:kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR];
        if (qtzArgsArray.count <= 0) {
            NSLog(@"[ERROR] Can't process your quartz composition arguments. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
            exit(1);
        } else {
            for (NSString* qtzArg in qtzArgsArray) {
                NSArray* qtzArgArray = [qtzArg componentsSeparatedByString: kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR];
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
    NSString* argString = [[argument componentsSeparatedByString:kCMDLN_ARG_KEY_VALUE_SEPARATOR] lastObject];
    
    if ( ![argString hasPrefix:@"{"]) {
        NSLog(@"[ERROR] Can't process your image arguments. No opening \"{\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    } else if ( ![argument hasSuffix:@"}"]) {
        NSLog(@"[ERROR] Can't process your image arguments. No opening \"}\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    } else {
        argString = [argString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    }
    
    NSArray* paramArray = [argString componentsSeparatedByString:kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR];
    Boolean autoWidth   = YES;
    Boolean autoHeight  = YES;
    
    for (NSString* param in paramArray) {
        if ([param hasPrefix:kCMDLN_MEDIA_PATH_TRIGGER]) {
            NSString* path = [[param componentsSeparatedByString:kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR] lastObject];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                NSLog(@"[ERROR] Can't load image from path \"%@\". File does not exist.", path);
                exit(1);
            }
            NSLog(@"[INFO] Will load image from path \"%@\".", path);
            [_quartzArgumentsDictionary setValue:@"image" forKey:kQTZ_COMP_MEDIATYPE_PARAM_KEY];
            [_quartzArgumentsDictionary setValue:path forKey:kQTZ_COMP_MEDIAPATH_PARAM_KEY];
        }
        else if ([param hasPrefix:kCMDLN_MEDIA_WIDTH_TRIGGER]) {
            NSString* width = [[param componentsSeparatedByString:kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR] lastObject];
            if ([width isEqualToString:@"auto"]) {
                NSLog(@"[INFO] Will display image with auto width.");
            } else if ([width isEqualToString:@"full"]) {
                NSLog(@"[INFO] Will display image with full width.");
                autoWidth = NO;
                [_quartzArgumentsDictionary setValue:[NSString stringWithFormat:@"%f", _windowSize.width]
                                              forKey:kQTZ_COMP_MEDIAWIDTH_PARAM_KEY];
            } else if ( (double)[width doubleValue] > 0) {
                NSLog(@"[INFO] Will display image with width \"%@\".", width);
                autoWidth = NO;
                [_quartzArgumentsDictionary setValue:width forKey:kQTZ_COMP_MEDIAWIDTH_PARAM_KEY];
            } else {
                NSLog(@"[WARNING] Your given image width of \"%@\" can't be used. Will use \"auto\" instead.", width);
            }
        }
        else if ([param hasPrefix:kCMDLN_MEDIA_HEIGHT_TRIGGER]) {
            NSString* height = [[param componentsSeparatedByString:kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR] lastObject];
            if ([height isEqualToString:@"auto"]) {
                NSLog(@"[INFO] Will display image with auto height.");
            } else if ([height isEqualToString:@"full"]) {
                NSLog(@"[INFO] Will display image with full height.");
                autoHeight = NO;
                [_quartzArgumentsDictionary setValue:[NSString stringWithFormat:@"%f", _windowSize.height]
                                              forKey:kQTZ_COMP_MEDIAHEIGHT_PARAM_KEY];
            } else if ( (double)[height doubleValue] > 0) {
                NSLog(@"[INFO] Will display image with height \"%@\".", height);
                autoHeight = NO;
                [_quartzArgumentsDictionary setValue:height forKey:kQTZ_COMP_MEDIAHEIGHT_PARAM_KEY];
            } else {
                NSLog(@"[WARNING] Your given image height of \"%@\" can't be used. Will use \"auto\" instead.", height);
            }
        }
        
        if (autoHeight && autoWidth) {
            [_quartzArgumentsDictionary setValue:_windowSize.width >= _windowSize.height ? @"auto" : [NSString stringWithFormat:@"%f", _windowSize.width]
                                          forKey:kQTZ_COMP_MEDIAWIDTH_PARAM_KEY];
            [_quartzArgumentsDictionary setValue:_windowSize.width >= _windowSize.height ? [NSString stringWithFormat:@"%f", _windowSize.height] : @"auto"
                                          forKey:kQTZ_COMP_MEDIAHEIGHT_PARAM_KEY];
            
        }
    }
}

/*!
 This method will process the passed argument into a path to a video and additional parameters for that video. The video will be shown inside the Quartz composition.
 \param argument The argument that contains the video path and the additional parameters.
 */
- (void)processVideoFromArgument:(NSString *)argument {
    NSString* argString = [[argument componentsSeparatedByString:kCMDLN_ARG_KEY_VALUE_SEPARATOR] lastObject];
    Boolean autoWidth   = YES;
    Boolean autoHeight  = YES;
    
    if ( ![argString hasPrefix:@"{"]) {
        NSLog(@"[ERROR] Can't process your video arguments. No opening \"{\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    } else if ( ![argument hasSuffix:@"}"]) {
        NSLog(@"[ERROR] Can't process your video arguments. No opening \"}\" for argument list found. Arguments have to be surrounded by \"{ }\" and separated by \",\"to be accepted.");
        exit(1);
    } else {
        argString = [argString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    }
    
    NSArray* paramArray = [argString componentsSeparatedByString:kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR];
    
    for (NSString* param in paramArray) {
        if ([param hasPrefix:kCMDLN_MEDIA_PATH_TRIGGER]) {
            NSString* path = [[param componentsSeparatedByString:kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR] lastObject];
            
            if (![path hasSuffix:@".mov"]) {
                NSLog(@"[ERROR] Can't load video from path \"%@\". Only files inside a MOV (*.mov) container are supported.", path);
                exit(1);
            } else if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                NSLog(@"[ERROR] Can't load video from path \"%@\". File does not exist.", path);
                exit(1);
            }
            NSLog(@"[INFO] Will load video from path \"%@\".", path);
            [_quartzArgumentsDictionary setValue:@"video" forKey:kQTZ_COMP_MEDIATYPE_PARAM_KEY];
            [_quartzArgumentsDictionary setValue:path forKey:kQTZ_COMP_MEDIAPATH_PARAM_KEY];
        } else if ([param hasPrefix:kCMDLN_MEDIA_WIDTH_TRIGGER]) {
            NSString* width = [[param componentsSeparatedByString:kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR] lastObject];
            if ([width isEqualToString:@"auto"]) {
                NSLog(@"[INFO] Will display image with auto width.");
            } else if ([width isEqualToString:@"full"]) {
                NSLog(@"[INFO] Will display image with full width.");
                autoWidth = NO;
                [_quartzArgumentsDictionary setValue:[NSString stringWithFormat:@"%f", _windowSize.width]
                                              forKey:kQTZ_COMP_MEDIAWIDTH_PARAM_KEY];
            } else if ( (double)[width doubleValue] > 0) {
                NSLog(@"[INFO] Will display image with width \"%@\".", width);
                autoWidth = NO;
                [_quartzArgumentsDictionary setValue:width forKey:kQTZ_COMP_MEDIAWIDTH_PARAM_KEY];
            } else {
                NSLog(@"[WARNING] Your given image width of \"%@\" can't be used. Will use \"auto\" instead.", width);
            }
        } else if ([param hasPrefix:kCMDLN_MEDIA_HEIGHT_TRIGGER]) {
            NSString* height = [[param componentsSeparatedByString:kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR] lastObject];
            if ([height isEqualToString:@"auto"]) {
                NSLog(@"[INFO] Will display video with auto height.");
            } else if ([height isEqualToString:@"full"]) {
                NSLog(@"[INFO] Will display video with full height.");
                autoHeight = NO;
                [_quartzArgumentsDictionary setValue:[NSString stringWithFormat:@"%f", _windowSize.height]
                                              forKey:kQTZ_COMP_MEDIAHEIGHT_PARAM_KEY];
            } else if ( (double)[height doubleValue] > 0) {
                NSLog(@"[INFO] Will display video with height \"%@\".", height);
                autoHeight = NO;
                [_quartzArgumentsDictionary setValue:height forKey:kQTZ_COMP_MEDIAHEIGHT_PARAM_KEY];
            } else {
                NSLog(@"[WARNING] Your given video height of \"%@\" can't be used. Will use \"auto\" instead.", height);
            }
        } else if ([param hasPrefix:kCMDLN_MEDIA_LOOP_TRIGGER]) {
            NSString* loops = [[param componentsSeparatedByString:kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR] lastObject];
            if ([loops intValue] <= 0) {
                NSLog(@"[INFO] You set a number of zero or less loops. Your video will loop infinitly.");
                [_quartzArgumentsDictionary setValue:kQTZ_COMP_DEFAULT_MEDIALOOPS forKey:kQTZ_COMP_MEDIALOOPS_PARAM_KEY];
            } else {
                NSLog(@"[INFO] Will set loops to %d.", [loops intValue]);
                [_quartzArgumentsDictionary setValue:[NSNumber numberWithInt:[loops intValue]] forKey:kQTZ_COMP_MEDIALOOPS_PARAM_KEY];
            }
        } else if ([param hasPrefix:kCMDLN_MEDIA_RATE_TRIGGER]) {
            NSString* rate = [[param componentsSeparatedByString:kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR] lastObject];
            if ((NSInteger*)[rate integerValue] != nil) {
                NSLog(@"[INFO] Will use %@ as video rate.", rate);
                [_quartzArgumentsDictionary setValue:rate forKey:kQTZ_COMP_MEDIARATE_PARAM_KEY];
            } else {
                NSLog(@"[WARNING] Can't use \"%@\" as video rate. Will use %@ instead.",rate, kQTZ_COMP_DEFAULT_MEDIARATE);
                [_quartzArgumentsDictionary setValue:kQTZ_COMP_DEFAULT_MEDIARATE forKey:kQTZ_COMP_MEDIARATE_PARAM_KEY];
            }
            
        } else  if ([param hasPrefix:kCMDLN_MEDIA_START_TRIGGER ]) {
            NSString* start = [[param componentsSeparatedByString:kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR] lastObject];
            if ([start floatValue] < 0) {
                NSLog(@"[WARNING] Your given video start time of \"%@\" can't be used. Will use %@ instead.", start, kQTZ_COMP_DEFAULT_MEDIASTART);
                [_quartzArgumentsDictionary setValue:kQTZ_COMP_DEFAULT_MEDIASTART forKey:kQTZ_COMP_MEDIASTART_PARAM_KEY];
            }
            else {
                NSLog(@"[INFO] Will start video at \"%@\" seconds.", start);
                [_quartzArgumentsDictionary setValue:start forKey:kQTZ_COMP_MEDIASTART_PARAM_KEY];
            }
        } else if ([param hasPrefix:kCMDLN_MEDIA_DURATION_TRIGGER]) {
            NSString* duration = [[param componentsSeparatedByString:kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR] lastObject];
            if ((float)[duration floatValue] <= 0.0f) {
                NSLog(@"[WARNING] Your given video duration is less or equal to 0.0 therefore will be ignored.");
                [_quartzArgumentsDictionary setValue:kQTZ_COMP_DEFAULT_MEDIADURATION forKey:kQTZ_COMP_MEDIADURATION_PARAM_KEY];
            } else {
                NSLog(@"[INFO] Will use %@ as video duration as long as it won't exeed the duration of full video.", duration);
                [_quartzArgumentsDictionary setValue:duration forKey:kQTZ_COMP_MEDIADURATION_PARAM_KEY];
            }
        }
        
        if (autoHeight && autoWidth) {
            [_quartzArgumentsDictionary setValue:_windowSize.width >= _windowSize.height ? @"auto" : [NSString stringWithFormat:@"%f", _windowSize.width]
                                          forKey:kQTZ_COMP_MEDIAWIDTH_PARAM_KEY];
            [_quartzArgumentsDictionary setValue:_windowSize.width >= _windowSize.height ? [NSString stringWithFormat:@"%f", _windowSize.height] : @"auto"
                                          forKey:kQTZ_COMP_MEDIAHEIGHT_PARAM_KEY];
            
        }
    }
}

@end

