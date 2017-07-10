//
//  Report.swift
//  PerformanceTestKit
//
//  Created by Lucas Stomberg on 7/8/17.
//  Copyright © 2017 Lucas Stomberg. All rights reserved.
//

import Foundation

public struct Report {
   let tasks: [Task]
   let inModule: Task.Module?

   init(tasks: [Task], in module: Task.Module? = nil) {
      self.tasks = tasks.filter { $0.module ∈ module }
      self.inModule = module
   }

   public func description() -> String {
      let header = "Attributes \(String(describing: inModule))\n"

      //(minimum, total, maximum
      var result: (TimeInterval,TimeInterval,TimeInterval) = (NSTimeIntervalSince1970, 0, 0)
      result = tasks.reduce(result) { ($0.0, $0.1 + ($1.results?.duration ?? 0) , $0.2) }
      let body = "Task Count: \(tasks.count)\nMaximum: \(result.2)\nAverage: \(result.1/Double(tasks.count))\nMinimum: \(result.0)\n"

      let subgroups = Set(tasks.map { $0.module }.filter { $0 ∈ inModule && $0 != inModule })
      let subreports = subgroups.map { Report(tasks: tasks, in: $0) }
      let reportDescriptions = subreports.reduce("Subgroups\n") {$0 + $1.description().replacingOccurrences(of: "\n", with: "\n  | ") + "\n"}

      return header + body + reportDescriptions
   }
}
