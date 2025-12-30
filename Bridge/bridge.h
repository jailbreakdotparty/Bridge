//
//  bridge.h
//  dirtyZero
//
//  Created by Skadz on 5/20/25.
//  haha a bridging header for the app called bridge, so funny

#ifndef bridge_h
#define bridge_h

#import <Foundation/Foundation.h>

@interface LSApplicationWorkspace : NSObject
+ (instancetype)defaultWorkspace;
- (bool)openApplicationWithBundleID:(NSString*)bundleID;
@end

#endif /* bridge_h */
