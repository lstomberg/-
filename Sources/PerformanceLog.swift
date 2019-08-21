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

extension PerformanceLog.Data : Codable { }

public class PerformanceLog {

   // ** Storage **
   struct Data {
      let name: String = "PerformanceLog"
      var completedTasks: [Task] = []
      var runningTasks: [Task] = []
   }

   enum RunningTaskError: Error {
      case invalidNumberOfTasksRemoved([Task],Module)
   }

   public static let `default` = PerformanceLog()

   var data = Data()

   init() {
      NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
   }

   deinit {
      NotificationCenter.default.removeObserver(self)
   }

   @objc
   func save() {

#if swift(>=3.2)
      guard let encodedData = try? JSONEncoder().encode(data) else {
         return
      }
      try? encodedData.write(to: data.filePath)
#else
      print("Saving is not supported in Swift 3")
#endif
   }

   // MARK: PUBLIC API
   public func startTask(named name:String, inModule module:Module, storingDetails details:String? = nil) throws {
      if case let removedTasks = data.runningTasks.remove(taskIn: module, named: name), removedTasks.count > 1 {
         throw RunningTaskError.invalidNumberOfTasksRemoved(removedTasks,module)
      }
      data.runningTasks.append(Task(named: name, in: module, executionDetails: details))
   }

   func endTask(inModule module: Module, named name: String, storingParition partition:String? = nil) throws {
      let removedTasks = data.runningTasks.remove(taskIn: module, named: name)
      guard let task = removedTasks.first, removedTasks.count == 1 else {
         throw RunningTaskError.invalidNumberOfTasksRemoved(removedTasks, module)
      }
      data.completedTasks.append(task.complete(partition: partition))
   }

   func report() -> Report {
      return Report(tasks: data.completedTasks)
   }
}

extension PerformanceLog.Data {

   var filePath: URL {
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
      return URL(fileURLWithPath:documentsPath + "/" + name + ".plist")
   }

}
