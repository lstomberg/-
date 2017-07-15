//  MIT License
//
//  Copyright (c) 2017 Lucas Stomberg
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files \(the "Software"\), to deal
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

import UIKit
import PlaygroundSupport
import PerformanceTestKit

let name="Store"
let module = Module(name:"Lucas",segment:"none")

try? PerformanceLog.default.startTask(named: name, inModule: module)
try? PerformanceLog.default.endTask(inModule: module, named: name, storingParition: "3")

try? PerformanceLog.default.startTask(named: name, inModule: module)
try? PerformanceLog.default.endTask(inModule: module, named: name, storingParition: "6")

try? PerformanceLog.default.startTask(named: name, inModule: Module(name:"James",segment:nil))
try? PerformanceLog.default.endTask(inModule: Module(name:"James",segment:nil), named: name, storingParition: "13")

try? PerformanceLog.default.startTask(named: name, inModule: Module(name:"Lucas",segment:nil))
try? PerformanceLog.default.endTask(inModule: Module(name:"Lucas",segment:nil), named: name, storingParition: "18")

try? PerformanceLog.default.startTask(named: name+"a", inModule: Module(name:"Lucas",segment:nil))
try? PerformanceLog.default.endTask(inModule: Module(name:"Lucas"), named: name+"a", storingParition: "18")

PerformanceLog.default.data.completedTasks
let report = PerformanceLog.default.report()

report.tasks
report.inModule

let desc = report.debugDescription
print(desc)

//PerformanceLog.default.data.runningTasks
//PerformanceLog.default.data.completedTasks

//let dispatchQueue = DispatchQueue(label: "testQueue")
//
//dispatchQueue.asyncAfter(deadline: .now() + 2) {
//   PerformanceLog.default.data.runningTasks
//   try? PerformanceLog.default.endTask(inModule: Module(name:"Lucas",segment:"none"), named: "Store")
//   PerformanceLog.default.data.runningTasks
//   PerformanceLog.default.data.completedTasks
//
//   let rpt = PerformanceLog.default.report()
//   rpt.tasks
//   print(rpt.description)
//   PlaygroundPage.current.finishExecution()
//}
//
//PlaygroundPage.current.needsIndefiniteExecution = true

