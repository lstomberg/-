//
//  Task.swift
//  PerformanceTestKit
//
//  Created by Lucas Stomberg on 7/8/17.
//  Copyright © 2017 Lucas Stomberg. All rights reserved.
//

import Foundation

infix operator ∈: AdditionPrecedence

struct Task : Codable {
  struct Module : Codable,Hashable {
    let name: String
    let segment: String?

    public static func ==(lhs:Module, rhs:Module) -> Bool {
      return lhs.name == rhs.name && lhs.segment == rhs.segment
    }
    public var hashValue: Int {
      get {
        return name.hashValue + (segment?.hashValue ?? 0)
      }
    }

    public static func ∈(lhs:Module, rhs:Module?) -> Bool {
      guard let rhs = rhs else {
        return true
      }
      return (lhs.name == rhs.name && (rhs.segment == nil || lhs.segment == rhs.segment))
    }
  }

  struct Result : Codable {
    let duration: TimeInterval
  }

  let module:Module
  let name:String
  let executionDetails: String?
  let startTime = Date()

  let partition:String?
  let results: Result?

  init(named:String, in module:Module, executionDetails: String? = nil, partition: String? = nil, result: Result? = nil) {
    self.name = named
    self.module = module
    self.executionDetails = executionDetails
    self.partition = partition
    self.results = result
  }
}

extension Task {
  func complete(partition: String?) -> Task {
    let result = Result(duration: Date().timeIntervalSince(startTime))
    return Task(named: name, in: module, executionDetails: executionDetails, partition: partition, result: result)
  }
}

extension Array where Element == Task {
  mutating func remove(taskIn module: Task.Module, named name:String) -> [Task] {
    let removed = self.filter { $0.module == module && $0.name == name }
    self = self.filter { !($0.module == module && $0.name == name) }
    return removed
  }
}




