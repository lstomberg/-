//
//  TestSupport.swift
//  PerformanceTestKitTests
//
//  Created by Lucas Stomberg on 7/11/17.
//  Copyright © 2017 Lucas Stomberg. All rights reserved.
//

import Foundation

extension Equatable {
   //   infix operator ∈: AdditionPrecedence
   static func ∈<T:Collection>(object: Self, collection:T) -> Bool where T.Iterator.Element == Self  {
      return collection.contains { $0 == object }
   }
}

/*
 * VARIABLE SETUP
 */

struct Test {
   var index = (int: 0, string: 0, module: 0, task: 0)
   static let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-=_+[];',./{}|:<>?"

   static func string(unique int: Int, length: Int = 6) -> String {
      let startOffset = int % characters.count
      let multiple = int / characters.count

      var string = "".padding(toLength: multiple, withPad: " ", startingAt: 0)
      for mIndex in 0..<length {
         let offset = (startOffset + multiple*mIndex) % characters.count
         let index = characters.index(characters.startIndex, offsetBy: offset)
         string = string.appending(String(characters[index]))
      }
      return string
   }

   static func int(unique int: Int) -> Int {
      return int
   }

   static func module(unique int: Int, withSegment: Bool) -> Module {
      return Module(name: string(unique: int, length: 6), segment: withSegment ? string(unique: int+1) : nil)
   }

   static func partition(unique int: Int) -> String {
      return string(unique: int, length: 2)
   }

//   static func task(unique int: Int, withSegment: Bool) -> Task {
//      let name = self.string(unique: int)
//      let module = self.module(unique: int+1, withSegment: withSegment)
//      let executionDetails = "details"
//      let startTime = Date(timeIntervalSince1970: TimeInterval(int+2))
//      let partition = self.partition(unique: int+3)
//      let results = Task.Result(duration:Double(int))
//      return Task(name: name, module: module, executionDetails: executionDetails, startTime: startTime, partition: partition, results: results)
//   }
//
//   static func task(unique int: Int, withSegment: Bool, count: Int) -> [Task] {
//      var tasks: [Task] = []
//      for unique in int...(int+count) {
//         tasks.append(task(unique:unique, withSegment: withSegment))
//      }
//      return tasks
//   }
}


extension Task {
   func withNew(name:String) -> Task {
      return Task(name: name, module: module, executionDetails: executionDetails, startTime: startTime, partition: partition, results: results)
   }

   func withNew(module:Module) -> Task {
      return Task(name: name, module: module, executionDetails: executionDetails, startTime: startTime, partition: partition, results: results)
   }

   func withNew(partition:String?) -> Task {
      return Task(name: name, module: module, executionDetails: executionDetails, startTime: startTime, partition: partition, results: results)
   }

   func withNew(resultsDuration duration:Double) -> Task {
      return Task(name: name, module: module, executionDetails: executionDetails, startTime: startTime, partition: partition, results: Task.Result(duration:duration))
   }

   func withNew(startTime:Date) -> Task {
      return Task(name: name, module: module, executionDetails: executionDetails, startTime: startTime, partition: partition, results: results)
   }
}








//extension TestVariables {
//   mutating func nextString(_ length: Int = 1) -> String {
//      index.string = index.string + 1
//      return TestVariables.string(unique: index.string)
//   }
//
//   mutating func nextInt() -> Int {
//      index.int = index.int + 1
//      return TestVariables.int(unique: index.int)
//   }
//
//   mutating func nextModule(withSegment: Bool) -> Module {
//      index.module = index.module + 1
//      return TestVariables.module(unique: index.module, withSegment: withSegment)
//   }
//
//   mutating func nextTask(withSegment: Bool) -> Task {
//      index.task = index.task + 1
//      return TestVariables.task(unique: index.task, withSegment: withSegment)
//   }
//}




























