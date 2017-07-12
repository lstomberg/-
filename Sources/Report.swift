//
//  Report.swift
//  PerformanceTestKit
//
//  Created by Lucas Stomberg on 7/8/17.
//  Copyright © 2017 Lucas Stomberg. All rights reserved.
//

import Foundation


public struct Report : CustomStringConvertible,CustomDebugStringConvertible {
   struct Filter {
      let module: Module?
      let partition: String??
      let name: String?
   }

   let tasks: [Task]
   let filter: Filter

   init(tasks: [Task], filter: Filter = Filter()) {
      self.filter = filter
      self.tasks = filter.tasks(tasks)
   }

   public var description: String {
      get {
         return printi() //figure out how to strip debug info later
      }
   }

   public var debugDescription: String {
      get {
         return printi()
      }
   }

//   func taskResults(tasks: )

   func printi() -> String {
      var result = (10000.0,0.0,0.0)
      result = tasks.reduce(result) { (arg0,task) in
         var (min, total, max) = arg0
         let duration = task.results!.duration
         min = Double.minimum(min, duration)
         total += duration
         max = Double.maximum(max, duration)
         return (min,total,max)
      }
      let filters = filter.childFilters(forTasks: tasks)

      var description = "Report"

      let shouldDisplayDetails = tasks.count > 1 || filters.isEmpty
      if(shouldDisplayDetails) {
         let filterDescription = String(describing: filter)
         let taskCount = "Task Count: \(tasks.count)"
         let maximumDuration = "Maximum: \(result.2)s"
         let averageDuration = "Average: \(result.1/Double(tasks.count))s"
         let minimumDuration = "Minimum: \(result.0)s"
         description += "\n " + [filterDescription, taskCount, maximumDuration, averageDuration, minimumDuration].joined(separator: "\n ")
      }

      if !filters.isEmpty {
         var reports: [String] = filters.map { Report(tasks: tasks, filter: $0).description }
         if let special = reports.last {
            reports.remove(at: reports.endIndex-1)
            reports = reports.map { $0.replacingOccurrences(of: "\n", with: "\n  |  ")}

            if !reports.isEmpty {
               description += "\n  ├--" + reports.joined(separator: "\n  ├--")
            }
            description += "\n  └--" + special.replacingOccurrences(of: "\n", with: "\n     ")
         }
      }

      return description
   }

}


extension Report.Filter {
   func childFilters(forTasks tasks: [Task]) -> [Report.Filter] {
      var filter = self
      if module == nil {
         let moduleNames = tasks.map { $0.module.name }
         let reports = moduleNames.map { Report.Filter(module: Module(name: $0), partition: nil, name: nil) }
         if reports.count != 1 {
            return reports
         } else {
            filter = reports.first!
         }
      }

      if let module = module, module.segment == nil {
         let subsegments = Set(tasks.flatMap { $0.module.segment })

         if !subsegments.isEmpty {
            let reports = subsegments.map { Report.Filter(module: Module(name: filter.module!.name, segment: $0), partition: nil, name: nil) }
            if reports.count != 1 {
               return reports
            } else {
               filter = reports.first!
            }
         }
      }

      if name == nil {
         let names = tasks.map { $0.name }
         let reports = names.map { Report.Filter(module: filter.module, partition: nil, name: $0) }
         if reports.count != 1 {
            return reports
         } else {
            filter = reports.first!
         }
      }

      if partition == nil {
         let partitions = tasks.map { $0.partition } //want nil
         return partitions.map { Report.Filter(module: filter.module, partition: $0, name: filter.name) }
      }

      return filter == self ? [] : [filter]
   }
}


extension Report.Filter : CustomDebugStringConvertible {
   init() {
      self.init(module: nil, partition: nil, name: nil)
   }

   func tasks<T:Sequence>(_ fromTasks: T) -> [Task] where T.Element == Task {
      var tasks = fromTasks.filter { $0.module ∈ module }
      tasks = tasks.filter { name == nil || $0.name == name! }

      //cant easily unwrap Optional<nil>
      if let unwrapped = partition {
         tasks = tasks.filter { $0.partition == unwrapped }
      }
      return tasks
   }

   public var description: String {
      get {
         var description: [String] = ["Filter:"]
         if let module = module {
            let string = "(Module: \(module.name), segment: \(String(describing: module.segment)))" //ideally we could strip segment somewhat
            description.append(string)
         }
         if let name = name {
            description.append("name: \(name)")
         }
         if let partition = partition {
            if let actualPartition = partition {
               description.append("partition: \(actualPartition)")
            }
         }
         return description.joined(separator: "  ")
      }
   }

   public var debugDescription: String {
      get {
         return description
      }
   }
}


extension Report.Filter : Equatable {
   static func ==(lhs:Report.Filter,rhs:Report.Filter) -> Bool {
      var equals = lhs.module == rhs.module && lhs.name == rhs.name
      if let arg0 = lhs.partition, let arg1 = rhs.partition {
         equals = equals || arg0 == arg1
      }
      return equals
   }
}

