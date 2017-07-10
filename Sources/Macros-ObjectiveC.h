//
//  Macros-ObjectiveC.h
//  PerformanceTestKit
//
//  Created by Lucas Stomberg on 7/8/17.
//  Copyright © 2017 Lucas Stomberg. All rights reserved.
//

#ifndef Macros_ObjectiveC_h
#define Macros_ObjectiveC_h

#define PTKStandardExecutionDetails [NSString stringWithFormat:@"%s [%s:%i]",__PRETTY_FUNCTION__, __FILE__, __LINE__]

#define TICK(taskName,segmentName,moduleName) \
    [[PTKPerformanceLog defaultLog] beginTask:^(PTKTaskConfiguration *config){ \
        config.identifiers.name = @"" # taskName; \
        config.identifiers.segment = @"" # segmentName; \
        config.identifiers.module = @"" # moduleName; \
        config.executionDetails = PTKStandardExecutionDetails; \
    } completion:nil]

#define TOCK(taskName,segmentName,moduleName,grouper) \
    [[PTKPerformanceLog defaultLog] endTask:({ \
        PTKTaskIdentifiers *identifiers = [PTKTaskIdentifiers new]; \
        identifiers.name = @"" # taskName; \
        identifiers.segment = @"" # segmentName; \
        identifiers.module = @"" # moduleName;  \
    identifiers; }) additionalGrouper:grouper]



#endif /* Macros_ObjectiveC_h */
