//
//  PerformanceLog.swift
//  PerformanceTestKit
//
//  Created by Lucas Stomberg on 7/8/17.
//  Copyright © 2017 Lucas Stomberg. All rights reserved.
//

import Foundation
import UIKit

public class PerformanceLog {

  // ** Storage **
  struct Data : Codable {
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
    NotificationCenter.default.addObserver(self, selector: #selector(save), name: .UIApplicationWillResignActive, object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc
  func save() {
    guard let encodedData = try? JSONEncoder().encode(data) else {
      return
    }
    try? encodedData.write(to: data.filePath)
  }

  //MARK: PUBLIC API
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


