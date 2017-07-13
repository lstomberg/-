//
//  ReportTests.swift
//  PerformanceTestKitTests
//
//  Created by Lucas Stomberg on 7/10/17.
//  Copyright © 2017 Lucas Stomberg. All rights reserved.
//

import XCTest
@testable import PerformanceTestKit

//XCTestCase classes are created once per test case, so the performance required to generate
//these tasks would be repeated for each case.  Putting it globally in tests to resolve this
let kTasks: [Task] = {
   var tasks: [Task] = []
   for uniqToken in 0...1000 where uniqToken % 8 == 5 {
      let name = Test.string(unique: uniqToken, length: 1+(uniqToken % 12))
      let module = Test.module(unique: uniqToken+10, withSegment: (uniqToken%2 == 0))
      let executionDetails = "details"
      let startTime = Date(timeIntervalSince1970: TimeInterval(uniqToken*7001))
      let partition = Test.partition(unique: uniqToken+3)
      let results = Task.Result(duration:Double(uniqToken))
      let task = Task(name: name, module: module, executionDetails: executionDetails, startTime: startTime, partition: partition, results: results)
      tasks.append(task)
   }
   print("***** Task Generation Statistics - (\(tasks.count) created)*****")
   return tasks
}()

class ReportTests: XCTestCase {
   func internal_filter(newTask:(Task)->Task, filter: Report.Filter, shouldPass: (Task)->Bool) {
      let tasks: [Task] = kTasks.enumerated().map { $0.0 % 2 == 0 ? $0.1 : newTask($0.1) }
      let passingTasks = filter.tasks(tasks)

      //ensure count is close to 1/2
      XCTAssertGreaterThanOrEqual(passingTasks.count, kTasks.count/2)

      //ensure filtered tasks meet filter
      let testPassingTasks = passingTasks.reduce(true) { $0 && shouldPass($1) }
      XCTAssertTrue(testPassingTasks)

      //probably none of kTasks were originally setup to pass so this will be whole set likely
      let removedTasks = kTasks.flatMap { return $0 ∈ passingTasks ? nil : $0 }

      //ensure all filtered tasks do not have moduleName
      let testRemovedTasks = removedTasks.reduce(false) { $0 || shouldPass($1)}

      XCTAssertFalse(testRemovedTasks)

      print("+++++ Filter Statistics - (\(passingTasks.count) passed, \(removedTasks.count) failed)\n")
   }



   /*
    * NIL FILTER
    */

   func test_filterNil() {
      let newTask: (Task)->Task = { $0 }
      let filter = Report.Filter(module: nil, partition: nil, name: nil)
      let shouldPass: (Task)->Bool = { _ in true }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   /*
    * NAME FILTER
    */
   func test_filterName() {
      let name = "243m./sz=';l42'[\\]80129m, zcxj"
      let newTask: (Task)->Task = { $0.withNew(name: name) }
      let filter = Report.Filter(module: nil, partition: nil, name: name)
      let shouldPass: (Task)->Bool = { $0.name == name }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   func test_filterNameEmpty() {
      let name = ""
      let newTask: (Task)->Task = { $0.withNew(name: name) }
      let filter = Report.Filter(module: nil, partition: nil, name: name)
      let shouldPass: (Task)->Bool = { $0.name == name }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   /*
    * MODULE FILTER
    */

   func test_filterModule_noSegment() {
      let module = Module(name: "aM4-/x\\=%snk832?.", segment: nil)
      let newTask: (Task)->Task = { $0.withNew(module: module) }
      let filter = Report.Filter(module: module, partition: nil, name: nil)
      let shouldPass: (Task)->Bool = { $0.module == module }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   func test_filterModuleEmptyString_noSegment() {
      let module = Module(name: "", segment: nil)
      let newTask: (Task)->Task = { $0.withNew(module: module) }
      let filter = Report.Filter(module: module, partition: nil, name: nil)
      let shouldPass: (Task)->Bool = { $0.module == module }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   func test_filterModule_segmentSameString() {
      let name = "2nls0af9-1;4m.s'-"
      let module = Module(name: name, segment: name)
      let newTask: (Task)->Task = { $0.withNew(module: module) }
      let filter = Report.Filter(module: module, partition: nil, name: nil)
      let shouldPass: (Task)->Bool = { $0.module == module }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   func test_filterModule_SegmentEmptyString() {
      let module = Module(name: "4381453", segment: "")
      let newTask: (Task)->Task = { $0.withNew(module: module) }
      let filter = Report.Filter(module: module, partition: nil, name: nil)
      let shouldPass: (Task)->Bool = { $0.module == module }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   func test_filterModule_segmentDifferentString() {
      let module = Module(name: "Test.string(unique: 0)", segment: "94k,sn")
      let newTask: (Task)->Task = { $0.withNew(module: module) }
      let filter = Report.Filter(module: module, partition: nil, name: nil)
      let shouldPass: (Task)->Bool = { $0.module == module }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   /*
    * MODULE FILTER
    */

   func test_filterPartitionEmptyString() {
      let partition = ""
      let newTask: (Task)->Task = { $0.withNew(partition: partition) }
      let filter = Report.Filter(module: nil, partition: partition, name: nil)
      let shouldPass: (Task)->Bool = { $0.partition == partition }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   func test_filterPartition() {
      let partition = "092[834;lkm.,dsz0"
      let newTask: (Task)->Task = { $0.withNew(partition: partition) }
      let filter = Report.Filter(module: nil, partition: partition, name: nil)
      let shouldPass: (Task)->Bool = { $0.partition == partition }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   func test_filterPartitionSingleChar() {
      do {
         let partition = "0"
         let newTask: (Task)->Task = { $0.withNew(partition: partition) }
         let filter = Report.Filter(module: nil, partition: partition, name: nil)
         let shouldPass: (Task)->Bool = { $0.partition == partition }

         internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
      }

      do{
         let partition = "9"
         let newTask: (Task)->Task = { $0.withNew(partition: partition) }
         let filter = Report.Filter(module: nil, partition: partition, name: nil)
         let shouldPass: (Task)->Bool = { $0.partition == partition }

         internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
      }

      do{
         let partition = "]"
         let newTask: (Task)->Task = { $0.withNew(partition: partition) }
         let filter = Report.Filter(module: nil, partition: partition, name: nil)
         let shouldPass: (Task)->Bool = { $0.partition == partition }

         internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
      }
   }

   /*
    * MULTI FILTER
    */

   func test_filterNameModuleSegment() {
      let name = "45wedfserq"
      let module = Module(name: "4381453", segment:"92m,sd;o-q")
      let newTask: (Task)->Task = { $0.withNew(module: module).withNew(name: name) }
      let filter = Report.Filter(module: module, partition: nil, name: name)
      let shouldPass: (Task)->Bool = { $0.name == name && $0.module == module }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }

   func test_filterNameModuleSegmentPartition() {
      let name = "TheName"
      let module = Module(name: "ModuleName", segment:"SEGMENT")
      let partition = "3"
      let newTask: (Task)->Task = { $0.withNew(module: module).withNew(name: name).withNew(partition: partition) }
      let filter = Report.Filter(module: module, partition: partition, name: name)
      let shouldPass: (Task)->Bool = { $0.name == name && $0.module == module && $0.partition == partition }

      internal_filter(newTask: newTask, filter: filter, shouldPass: shouldPass)
   }
}


//Running a test seems faster than running a playgrounds and I dont need any
//window, just the console for output, so adding some misc code here
extension ReportTests {

   func internal___OUTPUT___realisticTasks() -> [Task] {
      var tasks: [Task] = []
      //      for e in 0...100 {
      //         let (n,m,s,st,p,r) = (e%30,e%8,e%16,e%8,e%10,e%42)
      //         let name = Test.string(unique: n,length: 9)
      //         let module = Test.module(unique: m, withSegment: (s%8 != 0))
      //         let startTime = Date(timeIntervalSinceNow: Double(st))
      //         let partition = Test.partition(unique: p)
      //         let results = Task.Result(duration:0.01+Double(r^r/(84000)))
      //         let task = Task(name: name, module: module, executionDetails: nil, startTime: startTime, partition: partition, results: results)
      //         tasks.append(task)
      //      }
      for e in 0..<100 {
         let (n,m,s,p,st,r) = (e%3,10+e%3,2+e%3,e%2,e%10,e%42)
         let name = Test.string(unique: n,length: 9)
         let module = Test.module(unique: m, withSegment: s != 0)
         let partition:String? = Test.partition(unique: p)
         let startTime = Date(timeIntervalSinceNow: Double(st))
         let results = Task.Result(duration:0.01+Double(r^r/(84000)))
         let task = Task(name: name, module: module, executionDetails: nil, startTime: startTime, partition: partition, results: results)
         tasks.append(task)
      }
      print("***** OUTPUT Reaslistic Task Generation Statistics - (\(tasks.count) created)*****")
      return tasks
   }

   func test___OUTPUT___() {
      for t in internal___OUTPUT___realisticTasks() {
         print(t)
      }
      let report = Report(tasks: internal___OUTPUT___realisticTasks())
      print (report.description)
   }
}




