//
//  bridge.h
//  dirtyZero
//
//  Created by Skadz on 5/20/25.
//  thanks again skadz
//  i'm not sure how much of this application was indirectly made by you atp
//  sorry twin
//

#ifndef bridge_h
#define bridge_h

#import <Foundation/Foundation.h>

@interface LSApplicationWorkspace : NSObject
+ (instancetype)defaultWorkspace;
- (bool)openApplicationWithBundleID:(NSString*)bundleID;
@end

#endif /* bridge_h */
