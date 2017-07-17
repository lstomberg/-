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

import XCTest

class TestSupportTests: XCTestCase {

   /*
    * UNIQUE VARIABLES
    */

   func test_stringUnique() {
      var allString: [String] = [""]
      for index in 0...1000 where index % 50 == 3 {
         for length in 1...40 where length % 7 == 1 {
            allString.append(Test.string(unique: index, length: length))
            XCTAssertTrue(Test.string(unique: index, length: length) == Test.string(unique: index, length: length),
                          "Failed with unique \(index) and length \(length)")
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
      for index in 0...1000 where index % 53 == 8 {
         allModule.append(Test.module(unique: index, withSegment: false))
         XCTAssertTrue(Test.module(unique: index, withSegment: false) == Test.module(unique: index, withSegment: false),
                       "Failed with unique \(index)")
      }

      for index in 0...1000 where index % 47 == 19 {
         allModule.append(Test.module(unique: index, withSegment: true))
         XCTAssertTrue(Test.module(unique: index, withSegment: true) == Test.module(unique: index, withSegment: true),
                       "Failed with unique \(index)")
      }

      XCTAssertTrue(allModule.count == Set(allModule).count, "Not all unique")
   }
}
