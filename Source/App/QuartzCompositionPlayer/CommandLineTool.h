//
//  CommandLineTool.h
//  QuartzCompositionPlayer
//
//  Created by Erik on 16.07.14.
//  Copyright (c) 2014 HTW Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kCMDLN_TRIGGER_HELP;
extern NSString* const kCMDLN_TRIGGER_SIZE;
extern NSString* const kCMDLN_TRIGGER_ORIGIN;
extern NSString* const kCMDLN_TRIGGER_COMPOSITION;
extern NSString* const kCMDLN_TRIGGER_WEBSITE;
extern NSString* const kCMDLN_TRIGGER_ARGS;
extern NSString* const kCMDLN_SEPARATOR_ARG_KEY_VALUE;
extern NSString* const kCMDLN_SEPARATOR_ARG_VALUE_SUBKEY_SUBVALUE;
extern NSString* const kCMDLN_SEPARATOR_ARG_VALUE_SUBVALUE_SUBVALUE;
extern NSString* const kCMDLN_ARG_LEDGRID;
extern NSString* const kCMDLN_ARG_LEDCOMPLETE;

extern NSString* const kCMDLN_TRIGGER_MEDIA_IMAGE;
extern NSString* const kCMDLN_TRIGGER_MEDIA_VIDEO;
extern NSString* const kCMDLN_TRIGGER_MEDIA_PRESENTATION;
extern NSString* const kCMDLN_TRIGGER_MEDIA_PATH;
extern NSString* const kCMDLN_TRIGGER_MEDIA_WIDTH;
extern NSString* const kCMDLN_TRIGGER_MEDIA_HEIGHT;
extern NSString* const kCMDLN_TRIGGER_MEDIA_LOOP;
extern NSString* const kCMDLN_TRIGGER_MEDIA_START;
extern NSString* const kCMDLN_TRIGGER_MEDIA_DURATION;
extern NSString* const kCMDLN_TRIGGER_MEDIA_RATE;
extern NSString* const kCMDLN_TRIGGER_MEDIA_CONTROL;
extern NSString* const kCMDLN_TRIGGER_WEBSITE_URL;

extern NSString* const kQTZCOMP_PARAMKEY_MEDIATYPE;
extern NSString* const kQTZCOMP_PARAMKEY_MEDIAPATH;
extern NSString* const kQTZCOMP_PARAMKEY_MEDIAWIDTH;
extern NSString* const kQTZCOMP_PARAMKEY_MEDIAHEIGHT;
extern NSString* const kQTZCOMP_PARAMKEY_MEDIASTART;
extern NSString* const kQTZCOMP_PARAMKEY_MEDIADURATION;
extern NSString* const kQTZCOMP_PARAMKEY_MEDIALOOPS;
extern NSString* const kQTZCOMP_PARAMKEY_MEDIARATE;
extern NSString* const kQTZCOMP_PARAMKEY_MEDIACONTROL;

extern NSString* const kQTZCOMP_PARAMDEFAULT_VIDEOSTART;
extern NSString* const kQTZCOMP_PARAMDEFAULT_VIDEODURATION;
extern NSString* const kQTZCOMP_PARAMDEFAULT_VIDEOLOOPS;
extern NSString* const kQTZCOMP_PARAMDEFAULT_VIDEORATE;
extern NSString* const kQTZCOMP_PARAMDEFAULT_PRESENTATIONDURATION;
extern NSString* const kQTZCOMP_PARAMDEFAULT_PRESENTATIONLOOPS;
extern NSString* const kQTZCOMP_PARAMDEFAULT_MEDIAWIDTH;
extern NSString* const kQTZCOMP_PARAMDEFAULT_MEDIAHEIGHT;
extern NSString* const kQTZCOMP_PARAMDEFAULT_MEDIACONTROL;

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
@property(retain,readonly) NSString             *websiteURL;
@property(assign,readonly) Boolean              hasCustomQuartzComposition;
@property(assign,readonly) Boolean              hasWebsite;
@property(assign,readonly) Boolean              hasMediaSet;

- (id)init __attribute__((unavailable("Use 'initWithArguments' instead.")));
- (id)initWithArguments:(NSArray *)commandLineArguments;

@end
