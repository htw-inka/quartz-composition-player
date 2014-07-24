//
//  CommandLineTool.h
//  QuartzCompositionPlayer
//
//  Created by Erik on 16.07.14.
//  Copyright (c) 2014 HTW Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kCMDLN_HELP_TRIGGER;
extern NSString* const kCMDLN_SIZE_TRIGGER;
extern NSString* const kCMDLN_ORIGIN_TRIGGER;
extern NSString* const kCMDLN_COMPOSITION_TRIGGER;
extern NSString* const kCMDLN_ARGS_TRIGGER;
extern NSString* const kCMDLN_ARG_KEY_VALUE_SEPARATOR;
extern NSString* const kCMDLN_ARG_LEDGRID;
extern NSString* const kCMDLN_ARG_LEDCOMPLETE;
extern NSString* const kCMDLN_ARG_VALUE_KEY_VALUE_SEPARATOR;
extern NSString* const kCMDLN_ARG_VALUE_VALUE_VALUE_SEPARATOR;

extern NSString* const kCMDLN_MEDIA_IMAGE_TRIGGER;
extern NSString* const kCMDLN_MEDIA_VIDEO_TRIGGER;
extern NSString* const kCMDLN_MEDIA_PRESENTATION_TRIGGER;
extern NSString* const kCMDLN_MEDIA_PATH_TRIGGER;
extern NSString* const kCMDLN_MEDIA_WIDTH_TRIGGER;
extern NSString* const kCMDLN_MEDIA_HEIGHT_TRIGGER;
extern NSString* const kCMDLN_MEDIA_LOOP_TRIGGER;
extern NSString* const kCMDLN_MEDIA_START_TRIGGER;
extern NSString* const kCMDLN_MEDIA_DURATION_TRIGGER;
extern NSString* const kCMDLN_MEDIA_RATE_TRIGGER;

extern NSString* const kQTZ_COMP_MEDIATYPE_PARAM_KEY;
extern NSString* const kQTZ_COMP_MEDIAPATH_PARAM_KEY;
extern NSString* const kQTZ_COMP_MEDIAWIDTH_PARAM_KEY;
extern NSString* const kQTZ_COMP_MEDIAHEIGHT_PARAM_KEY;
extern NSString* const kQTZ_COMP_MEDIASTART_PARAM_KEY;
extern NSString* const kQTZ_COMP_MEDIADURATION_PARAM_KEY;
extern NSString* const kQTZ_COMP_MEDIALOOPS_PARAM_KEY;
extern NSString* const kQTZ_COMP_MEDIARATE_PARAM_KEY;

extern const float kDEFAULT_WINDOW_WIDTH;
extern const float kDEFAULT_WINDOW_HEIGHT;
extern const float kDEFAULT_WINDOW_POS_X;
extern const float kDEFAULT_WINDOW_POS_Y;

extern const float kLEDGRID_WINDOW_WIDTH;
extern const float kLEDGRID_WINDOW_HEIGHT;
extern const float kLEDGRID_WINDOW_POS_X;
extern const float kLEDGRID_WINDOW_POS_Y;

extern const float kLEDCOMPLETE_WINDOW_WIDTH;
extern const float kLEDCOMPLETE_WINDOW_HEIGHT;
extern const float kLEDCOMPLETE_WINDOW_POS_X;
extern const float kLEDCOMPLETE_WINDOW_POS_Y;

@interface CommandLineTool : NSObject {
    Boolean _hasSizeSet;
    Boolean _hasOriginSet;
    Boolean _hasArgsSet;
    NSArray *_commandLineArguments;
}

@property(assign,readonly) NSPoint              windowOrigin;
@property(assign,readonly) NSSize               windowSize;
@property(retain,readonly) NSString             *customQuartzCompositionPath;
@property(retain,readonly) NSMutableDictionary  *quartzArgumentsDictionary;
@property(assign,readonly) Boolean              hasCustomQuartzComposition;
@property(assign,readonly) Boolean              hasMediaSet;

- (id)init __attribute__((unavailable("Use 'initWithArguments' instead.")));
- (id)initWithArguments:(NSArray *)commandLineArguments;

@end
