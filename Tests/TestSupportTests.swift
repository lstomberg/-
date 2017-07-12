//
//  TestSupportTests.swift
//  PerformanceTestKitTests
//
//  Created by Lucas Stomberg on 7/11/17.
//  Copyright © 2017 Lucas Stomberg. All rights reserved.
//

import XCTest

class TestSupportTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


//   func test_enumerate3() {
//
//      let a = [true,false]
//      let b = ["test", "foo"]
//      let c = [2.2, 3.14]
//      let d = enumerate(a: a, b: b, c: c)
//      let e = Array(d)
//
//      XCTAssert(e.count == 8)
//      XCTAssert(e[0] == (true,"test",2.2))
//      XCTAssert(e[1] == (false,"test",2.2))
//      XCTAssert(e[2] == (true,"foo",2.2))
//      XCTAssert(e[3] == (false,"foo",2.2))
//      XCTAssert(e[4] == (true,"test",3.14))
//      XCTAssert(e[5] == (false,"test",3.14))
//      XCTAssert(e[6] == (true,"foo",3.14))
//      XCTAssert(e[7] == (false,"foo",3.14))
//
//   }





   /*
    * UNIQUE VARIABLES
    */

   func test_stringUnique() {
      var allString: [String] = [""]
      for index in 0...1000 where index % 50 == 3 {
         for length in 1...40 where length % 7 == 1 {
            allString.append(Test.string(unique: index, length: length))
            XCTAssertTrue(Test.string(unique: index, length: length) == Test.string(unique: index, length: length), "Failed with unique \(index) and length \(length)")
         }
      }

      XCTAssertTrue(allString.count == Set(allString).count, "Not all unique")
   }

   func test_intUnique() {
      var allInt: [Int] = []
      for index in 0...1000 where index % 51 == 7 {
         allInt.append(Test.int(unique: index))
            XCTAssertTrue(Test.int(unique: index) == Test.int(unique: index), "Failed with unique \(index)")
      }

      XCTAssertTrue(allInt.count == Set(allInt).count, "Not all unique")
   }

   func test_moduleUnique() {
      var allModule: [Module] = []
      for index in 0...1000 where index % 53 == 8  {
         allModule.append(Test.module(unique: index, withSegment: false))
         XCTAssertTrue(Test.module(unique: index, withSegment: false) == Test.module(unique: index, withSegment: false), "Failed with unique \(index)")
      }

      for index in 0...1000 where index % 47 == 19 {
         allModule.append(Test.module(unique: index, withSegment: true))
         XCTAssertTrue(Test.module(unique: index, withSegment: true) == Test.module(unique: index, withSegment: true), "Failed with unique \(index)")
      }

      XCTAssertTrue(allModule.count == Set(allModule).count, "Not all unique")
   }

//   func test_taskUnique() {
//      var allTask: [Task] = []
//      for index in 0...1000 {
//         allTask.append(Test.task(unique: index, withSegment: false))
//         XCTAssertTrue(Test.task(unique: index, withSegment: false) == Test.task(unique: index, withSegment: false), "Failed with unique \(index)")
//      }
//
//      for index in 0...1000 {
//         allTask.append(Test.task(unique: index, withSegment: true))
//         XCTAssertTrue(Test.task(unique: index, withSegment: true) == Test.task(unique: index, withSegment: true), "Failed with unique \(index)")
//      }
//
//      XCTAssertTrue(allTask.count == Set(allTask).count, "Not all unique")
//   }
}
