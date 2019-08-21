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

infix operator ∈: AdditionPrecedence

#if swift(>=3.2)
   extension Module : Codable { }
   extension Task : Codable { }
   extension Task.Result : Codable { }
#endif

public struct Module : Hashable {

   let name: String
   let segment: String?

   public static func == (lhs:Module, rhs:Module) -> Bool {
      return lhs.name == rhs.name && lhs.segment == rhs.segment
   }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(segment)
    }

   // swiftlint:disable identifier_name
   static func ∈(lhs:Module, rhs:Module?) -> Bool {
   // swiftlint:enable identifier_name
      guard let rhs = rhs else {
         return true
      }
      return (lhs.name == rhs.name && (rhs.segment == nil || lhs.segment == rhs.segment))
   }

   public init(name: String, segment: String? = nil) {
      self.name = name
      self.segment = segment
   }
}

struct Task : Hashable {
   struct Result : Equatable {
      let duration: TimeInterval
   }

   let name: String
   let module: Module
   let executionDetails: String?
   let startTime: Date

   let partition: String?
   let results: Result?

   public static func == (lhs:Task, rhs:Task) -> Bool {
      return lhs.name == rhs.name
         && lhs.module == rhs.module
         && lhs.executionDetails == rhs.executionDetails
         && lhs.partition == rhs.partition
         && lhs.results == rhs.results
   }

   public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(module)
        hasher.combine(startTime)
        hasher.combine(executionDetails)
        hasher.combine(partition)
        hasher.combine(results?.duration)
   }
}

extension Task {

   init(named:String, in module:Module, executionDetails: String? = nil, partition: String? = nil, result: Result? = nil) {
      self.init(name: named, module: module, executionDetails: executionDetails, startTime: Date(), partition: partition, results: result)
   }

   func complete(partition: String?) -> Task {
      let result = Result(duration: Date().timeIntervalSince(startTime))
      return Task(named: name, in: module, executionDetails: executionDetails, partition: partition, result: result)
   }
}

extension Array where Element == Task {

   mutating func remove(taskIn module: Module, named name:String) -> [Task] {
      let removed = self.filter { $0.module == module && $0.name == name }
      self = self.filter { !($0.module == module && $0.name == name) }
      return removed
   }
}
