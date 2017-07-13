//  MIT License
//
//  Copyright (c) 2017 Lucas Stomberg
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files \(the "Software"\), to deal
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

import Foundation


/*
 *
 * Randomization
 *
 */

extension Bool {

   static func random() -> Bool {
      return Int.random() % 2 == 0
   }
}

extension Int {

   static func random(_ range: ClosedRange<Int>) -> Int {
      return random(lowerBound: range.lowerBound, upperBound: range.upperBound)
   }

   static func random(lowerBound: Int, upperBound: Int) -> Int {
      //+1 is to account for rounding down for UInt32
      let random32 = arc4random_uniform(UInt32(upperBound - lowerBound + 1))
      return lowerBound + Int(random32)
   }

   static func random() -> Int {
      return Int(arc4random())
   }
}

extension Date {

   static func random(rangeInDays:ClosedRange<Double>) -> Date {
      let offsetLowerBound = rangeInDays.lowerBound * Double(86400)
      let offsetUpperBound = rangeInDays.upperBound * Double(86400)
      let offset = Double.random(lowerBound: offsetLowerBound,upperBound: offsetUpperBound)
      return Date(timeIntervalSinceNow: offset)
   }

   static func random() -> Date {
      let randomTime = TimeInterval(arc4random())
      return Date(timeIntervalSince1970: randomTime)
   }
}

extension Double {

   static func random(_ range: ClosedRange<Double>) -> Double {
      return random(lowerBound: range.lowerBound, upperBound: range.upperBound)
   }

   static func random(lowerBound: Double, upperBound: Double) -> Double {
      return random() * (upperBound - lowerBound) + lowerBound
   }

   //0..1
   static func random() -> Double {
      return Double(arc4random()) / Double(UINT32_MAX)
   }
}

extension String {

   static func random(length: Int) -> String {
      let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      let allowedCharsCount = UInt32(allowedChars.characters.count)
      var randomString = ""

      for _ in 0..<length {
         let randomNum = Int(arc4random_uniform(allowedCharsCount))
         let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
         let newCharacter = allowedChars[randomIndex]
         randomString += String(newCharacter)
      }

      return randomString
   }
}

extension Task {
   static func random( name:String? = nil,
                       module:Module? = nil,
                       executionDetails:String?? = nil,
                       startTime:Date? = nil,
                       results:Task.Result?? = nil,
                       partition:String?? = nil) -> Task {
      let uname: String = name ?? String.random(length: 6)
      let umodule: Module = module ?? Module(name: String.random(length: 6), segment: Bool.random() ? nil : String.random(length: 6))
      let uexecutionDetails:String? = executionDetails ?? (Bool.random() ? nil : String.random(length: 6))
      let ustartTime: Date = startTime ?? Date.random()
      let uresults: Result? = results ?? (Bool.random() ? nil : Task.Result(duration: Double.random()))
      let upartition: String? = partition ?? (Bool.random() ? nil : String.random(length: 6))

      return Task(name: uname, module: umodule, executionDetails: uexecutionDetails, startTime: ustartTime, partition: upartition, results: uresults)
   }

   static func random(count: Int,
                      name:String? = nil,
                      module:Module? = nil,
                      executionDetails:String?? = nil,
                      startTime:Date? = nil,
                      results:Task.Result?? = nil,
                      partition:String?? = nil) -> [Task] {
      var tasks = [Task]()
      for _ in 0..<count {
         tasks.append(Task.random(name: name,module: module,executionDetails: executionDetails,startTime: startTime,results: results,partition: partition))
      }
      return tasks
   }
}

