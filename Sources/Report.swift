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
      return printi() //figure out how to strip debug info later
   }

   public var debugDescription: String {
      return printi()
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

      let shouldDisplayDetails = filters.count > 1 || (filters.isEmpty && !filter.canDescend())
      if shouldDisplayDetails {
         let filterDescription = String(describing: filter)
         let taskCount = "Task Count: \(tasks.count)"
         let maximumDuration = "Maximum: \(result.2)s"
         let averageDuration = "Average: \(result.1 / Double(tasks.count))s"
         let minimumDuration = "Minimum: \(result.0)s"
         description += "\n " + [filterDescription, taskCount, maximumDuration, averageDuration, minimumDuration].joined(separator: "\n ")
      }

      if !filters.isEmpty {
         var reports: [String] = filters.map { Report(tasks: tasks, filter: $0).description }
         if let special = reports.last {
            reports.remove(at: reports.endIndex - 1)
            reports = reports.map { $0.replacingOccurrences(of: "\n", with: "\n  |  ") }

            if !reports.isEmpty {
               description += "\n  ├--" + reports.joined(separator: "\n  ├--")
            }
            description += "\n  └--" + special.replacingOccurrences(of: "\n", with: "\n     ") + "\n  |  "
         }
      }

      return description
   }

}

extension Report.Filter {
   func childFilters(forTasks tasks: [Task]) -> [Report.Filter] {
      var filter = self
      if filter.module == nil {
         let moduleNames = Set(tasks.map { $0.module.name }).sorted()
         let reports = moduleNames.map { Report.Filter(module: Module(name: $0), partition: nil, name: nil) }
         if reports.count != 1 {
            return reports
         } else {
            filter = reports.first!
         }
      }

      if let module = filter.module, module.segment == nil {
         let subsegments = Set(tasks.flatMap { $0.module.segment }).sorted()

         if !subsegments.isEmpty {
            let reports: [Report.Filter] = subsegments.map {
               let module = Module(name: filter.module!.name, segment: $0)
               return Report.Filter(module: module, partition: nil, name: nil)
            }

            if reports.count != 1 {
               return reports
            } else {
               filter = reports.first!
            }
         }
      }

      if filter.name == nil {
         let names = Set(tasks.map { $0.name }).sorted()
         let reports = names.map { Report.Filter(module: filter.module, partition: nil, name: $0) }
         if reports.count != 1 {
            return reports
         } else {
            filter = reports.first!
         }
      }

      if filter.partition == nil {
         let partitions = tasks.reduce([String?](), { ary,task in
            var ary = ary
            if !ary.contains(where: { $0 == task.partition }) {
               ary.append(task.partition)
            }
            return ary
         })
         return partitions.sorted(by: { (lhs, rhs) -> Bool in
            guard let lhs = lhs else {
               return true
            }
            if let rhs = rhs {
               return lhs < rhs
            }
            return false
         }).map { Report.Filter(module: filter.module, partition: $0, name: filter.name) }
      }

      return filter == self ? [] : [filter]
   }
}

extension Report.Filter : CustomDebugStringConvertible {
   func canDescend() -> Bool {
      guard self.partition != nil else {
         return true
      }
      return false
   }

   init() {
      self.init(module: nil, partition: nil, name: nil)
   }

   func tasks<T:Sequence>(_ fromTasks: T) -> [Task] where T.Iterator.Element == Task {
      var tasks = fromTasks.filter { $0.module ∈ module }
      tasks = tasks.filter { name == nil || $0.name == name! }

      //cant easily unwrap Optional<nil>
      if let unwrapped = partition {
         tasks = tasks.filter { $0.partition == unwrapped }
      }
      return tasks
   }

   public var description: String {
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

      if description.count == 1 {
         description.append("(empty)")
      }

      return description.joined(separator: " ")
   }

   public var debugDescription: String {
         return description
   }
}

extension Report.Filter : Equatable {
   static func == (lhs:Report.Filter,rhs:Report.Filter) -> Bool {
      var equals = lhs.module == rhs.module && lhs.name == rhs.name
      if let arg0 = lhs.partition, let arg1 = rhs.partition {
         equals = equals || arg0 == arg1
      }
      return equals
   }
}
