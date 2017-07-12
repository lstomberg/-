////
////  TestSupport-RandomTests.swift
////  PerformanceTestKitTests
////
////  Created by Lucas Stomberg on 7/11/17.
////  Copyright © 2017 Lucas Stomberg. All rights reserved.
////
//
//import XCTest
//
//class TestSupport_RandomTests: XCTestCase {
//
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//
//
//   func test_randomTaskArrayCountIsAccurate() {
//      for count in 0...20 {
//         let tasks = Task.random(name: count)
//         XCTAssertTrue( tasks.count == count )
//      }
//
//      let count = 294
//      let tasks = Task.random(name: count)
//      XCTAssertTrue( tasks.count == count )
//   }
//
//   func test_randomTaskArrayIsRandom() {
//      for count in 0...20 {
//         let tasks = Task.random(count)
//         for task in tasks {
//            XCTAssertTrue( tasks.filter { $0 == task }.count == 1 )
//         }
//      }
//
//      //larger case
//      let count = 314
//      let tasks = Task.random(count)
//      for task in tasks {
//         XCTAssertTrue( tasks.filter { $0 == task }.count == 1 )
//      }
//   }
//
//   func test_randomTaskArrayWithName() {
//      for _ in 1...40 {
//         let name = String.random(10)
//         let tasks = Task.random(10, name)
//         let filtered = tasks.filter { $0.name == name }
//         XCTAssertTrue(filtered == tasks)
//      }
//   }
//
//   func test_randomTaskArray_moduleNilSegment() {
//      for _ in 1...20 {
//         let name = String.random(6)
//         let module = Module(name: name, segment: nil)
//         let tasks = Task.random(10, nil, module)
//         let filtered = tasks.filter { $0.module == module }
//         XCTAssertTrue(filtered == tasks)
//      }
//   }
//
//   func test_randomTaskArray_moduleNonNilSegment() {
//      for _ in 1...40 {
//         let name = String.random(6)
//         let segment = String.random(6)
//         let module = Module(name: name, segment: segment)
//         let tasks = Task.random(10, nil, module)
//         let filtered = tasks.filter { $0.module == module }
//         XCTAssertTrue(filtered == tasks)
//      }
//   }
//
//   func test_randomTaskArray_explicitNilPartition() {
//      for _ in 1...20 {
//         let partition: String? = nil
//         let tasks = Task.random(10, nil, nil, nil, nil, nil, partition)
//         let filtered = tasks.filter { $0.partition == partition }
//         XCTAssertTrue(filtered == tasks)
//      }
//   }
//
//   func test_randomTaskArray_nonNilPartition() {
//      for _ in 1...20 {
//         let partition: String = String.random(10)
//         let tasks = Task.random(10, nil, nil, nil, nil, nil, partition)
//         let filtered = tasks.filter { $0.partition == partition }
//         XCTAssertTrue(filtered == tasks)
//      }
//   }
//
//}

