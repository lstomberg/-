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

import Foundation
import UIKit
import PlaygroundSupport
import PerformanceTestKit

let loginActivity = Activity(name: "Infrastructure", section: "Login")

let departmentTask = TaskConfiguration(name: "SetDepartment", activity: loginActivity)
let departmentTaskId = PerformanceLogger.default.start(departmentTask)
Thread.sleep(forTimeInterval: 0.5)
PerformanceLogger.default.end(task: departmentTaskId)

let downloadI18NTask = TaskConfiguration(name: "DownloadI18N", activity: loginActivity)
let downloadI18NTaskId = PerformanceLogger.default.start(downloadI18NTask)
Thread.sleep(forTimeInterval: 0.75)
PerformanceLogger.default.end(task: downloadI18NTaskId)

let scheduleActivity = Activity(name: "Schedule")
let loadScheduleTask = TaskConfiguration(name: "Load", activity: scheduleActivity)
let loadScheduleTaskId = PerformanceLogger.default.start(loadScheduleTask)
Thread.sleep(forTimeInterval: 0.2)
PerformanceLogger.default.end(task: loadScheduleTaskId)

let tomorrowScheduleActivity = Activity(name: "Schedule", section: "Tomorrow")
let loadTomorrowTask = TaskConfiguration(name: "Load", activity: tomorrowScheduleActivity)
let loadTomorrowTaskId = PerformanceLogger.default.start(loadTomorrowTask)
Thread.sleep(forTimeInterval: 0.1)
PerformanceLogger.default.end(task: loadTomorrowTaskId)

let report = PerformanceLogger.default.currentReport
print(report)
