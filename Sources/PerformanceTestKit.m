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
+ (void)TICKWithName:(NSString *_Nonnull)name activity:(NSString *_Nonnull)activity section:(NSString *_Nullable)section executionDetails:(NSString *_Nullable)executionDetails;
+ (void)TOCKWithName:(NSString *_Nonnull)name activity:(NSString *_Nonnull)activity section:(NSString *_Nullable)section additionalClassification:(NSString *_Nullable)additionalClassification;
+ (NSString *_Nonnull)performanceReport SWIFT_WARN_UNUSED_RESULT;
@end


//
// MARK: c apis
//
void _PTKTICK(NSString *_Nonnull name, NSString *_Nonnull activity, NSString *_Nullable section, NSString *_Nullable executionDetails) {
    [PTKObjCAPI TICKWithName:name activity:activity section:section executionDetails:executionDetails];
}

void _PTKTOCK(NSString *_Nonnull name, NSString *_Nonnull activity, NSString *_Nullable section, NSString *_Nullable additionalClassifier) {
    [PTKObjCAPI TOCKWithName:name activity:activity section:section additionalClassification:additionalClassifier];
}

NSString *_Nonnull NSStringReportFromPerformanceData() {
    return [PTKObjCAPI performanceReport];
}
