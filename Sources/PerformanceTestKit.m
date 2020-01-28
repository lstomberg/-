//
//  PerformanceTestKit.m
//  PerformanceTestKit
//
//  Created by Lucas Stomberg on 1/28/20.
//  Copyright © 2020 Lucas Stomberg. All rights reserved.
//

#import "PerformanceTestKit.h"
#import <PerformanceTestKit/PerformanceTestKit-Swift.h>

// copied from generated header *if* the swift class ObjCAPI were set to public
SWIFT_CLASS_NAMED("ObjCAPI")
@interface PTKObjCAPI : NSObject
+ (void)TICKWithName:(NSString * _Nonnull)name activity:(NSString * _Nonnull)activity section:(NSString * _Nullable)section;
+ (void)TOCKWithName:(NSString * _Nonnull)name activity:(NSString * _Nonnull)activity section:(NSString * _Nullable)section additionalClassification:(NSString * _Nullable)additionalClassification;
@end


//
// MARK: c apis
//
static void TICK(NSString *name, NSString *activity,  NSString * _Nullable section) {
    [PTKObjCAPI TICKWithName:name activity:activity section:section];
}

static void TOCK(NSString *name, NSString *activity, NSString * _Nullable section, NSString * _Nullable additionalClassifier) {
    [PTKObjCAPI TOCKWithName:name activity:activity section:section additionalClassification:additionalClassifier];
}
