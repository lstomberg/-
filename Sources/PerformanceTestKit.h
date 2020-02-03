//  MIT License
//
//  Copyright (c) 2017 Lucas Stomberg
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for PerformanceTestKit.
FOUNDATION_EXPORT double PerformanceTestKitVersionNumber;

//! Project version string for PerformanceTestKit.
FOUNDATION_EXPORT const unsigned char PerformanceTestKitVersionString[];

//
// Macros
//
#define PTKStandardExecutionDetails [NSString stringWithFormat:@"%s [%s:%i]",__PRETTY_FUNCTION__, __FILE__, __LINE__]

#define TICK(taskName,activityName,sectionName) \
    _PTKTICK(@"" # taskName, @"" # activityName, @"" # sectionName, PTKStandardExecutionDetails)

#define TOCK(taskName,activityName,sectionName,classifier) \
    _PTKTOCK(@"" # taskName, @"" # activityName, @"" # sectionName, @"" # classifier)

//
// PRIVATE APIs
//
void _PTKTICK(NSString *_Nonnull name, NSString *_Nonnull activity, NSString *_Nullable section, NSString *_Nullable executionDetails);
void _PTKTOCK(NSString *_Nonnull name, NSString *_Nonnull activity, NSString *_Nullable section, NSString *_Nullable additionalClassifier);

//
// REPORT
//
NSString *_Nonnull NSStringReportFromPerformanceData(void);
