//
//  DTOConfig.h
//  Dato
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#ifdef DEBUG
#define DEBUG_MODE 1
#else
#define DEBUG_MODE 0
#endif

@import Darwin.POSIX.libgen;
@import Foundation;

#import <AXKViewLayout/UIView+AXKViewLayout.h>

#import "UIColor+DTOAdditions.h"
#import "UIFont+DTOAdditions.h"

#ifndef ErrorLog
#define ErrorLog(format, ...) \
  do { \
    if (DEBUG_MODE) { \
      char buf[] = __FILE__; \
      NSLog([@" *** Error (%s:%d:%s): " stringByAppendingString:format], \
        basename(buf), __LINE__, __func__, # __VA_ARGS__); \
    } \
  } while (0)
#endif
