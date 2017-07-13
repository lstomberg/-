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

infix operator ∈: AdditionPrecedence

public struct Module : Codable,Hashable {
   let name: String
   let segment: String?

   public static func ==(lhs:Module, rhs:Module) -> Bool {
      return lhs.name == rhs.name && lhs.segment == rhs.segment
   }

   public var hashValue: Int {
      return name.hashValue ^ (segment?.hashValue ?? 0)
   }

   static func ∈(lhs:Module, rhs:Module?) -> Bool {
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

struct Task : Codable,Hashable {
   struct Result : Codable,Equatable {
      let duration: TimeInterval

      public static func ==(lhs:Task.Result,rhs:Task.Result) -> Bool {
         return lhs.duration == rhs.duration
      }
   }

   let name:String
   let module:Module
   let executionDetails: String?
   let startTime:Date

   let partition:String?
   let results: Result?

   public static func ==(lhs:Task,rhs:Task) -> Bool {
      return lhs.name == rhs.name
         && lhs.module == rhs.module
         && lhs.executionDetails == rhs.executionDetails
         && lhs.partition == rhs.partition
         && lhs.results == rhs.results
   }

   public var hashValue: Int {
      var hashValue = name.hashValue ^ module.hashValue ^ startTime.hashValue
      if let executionDetails = executionDetails {
         hashValue ^= executionDetails.hashValue
      }
      if let partition = partition {
         hashValue ^= partition.hashValue
      }
      if let results = results {
         hashValue ^= results.duration.hashValue
      }
      return hashValue
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




























//   public static func ==(lhs:Task, rhs:Task) {
//      let b: (Task)->AnyObject
//      let a: (Task,Task)->Bool = { $0.name == $1.name}
//
//      let properties: [(Task)->AnyObject] = []
//      return lhs.name == rhs.name &&
//   }








//      let a = Task(named: "", in: Module(name: "", segment: ""))
//      let b = Task(named: "", in: Module(name: "", segment: ""))
////      _ = .equal(rhs: b)
////      let c = a
////      c
//      _ = a.equal(rhs: b.self)
//
//      let c = b.self
//      let d = Task
//      let e:d = self
//      Task.equals(lhs: a, rhs: b)

//      _ = String.equals(lhs: self.name, rhs: name)
//      let a:Self&Equatable = self
//}

//   func asdf<Self>(type:Self) -> Self {
//      return self
//   }
//}

//extension String : GenericEquatable { }
//extension Task : GenericEquatable {}
//
//struct TypedEquatable<T> where T:Equatable {
//   public static func equals<T:Equatable>(lhs:T,rhs:T)->Bool {
//      return lhs == rhs
//   }
//}
//protocol GenericEquatable : Equatable {

//Equatable protocol defines == as being (Self,Self)->Bool
//This definition requires type information to be passed along since
//you cant call == on two Equatable objects unless the objects have
//the same class
//
//We need a function that explicitly requires the parameter types to be the same
//therefore we define a generic type and use a closure that takes two of those types explicitly

//   associatedtype EquatableType = Self.Type
////   func equals(_ obj:EquatableType)->Bool
//   static func equals(lhs:EquatableType, rhs:EquatableType)->Bool
//   func equal(rhs:EquatableType) -> Bool
//}
//
////extension GenericEquatable {
////   static func ==(lhs:EquatableType,rhs:EquatableType) -> Bool {
////      return true
////   }
////}
//
//extension Equatable where Self:GenericEquatable {
////   static func equals<GenericEquatable>(lhs:GenericEquatable, rhs:GenericEquatable) -> Bool {
////      return lhs.equals(rhs)
////   }
//
////   static func equalsSt(lhs:Self, rhs:Self)->Bool {
////      return equalsS(lhs: lhs, rhs: rhs)
////   }
//////
////   static func getGeneric<T>(_ object: T) -> T.Type {
////      return T.self
////   }
//
//   func equal(rhs:EquatableType) -> Bool {
//      let asdf:EquatableType = self as! EquatableType
//      return type(of: self).equals(lhs:asdf,rhs:rhs)
//   }
//
//   static func equals(lhs:Self.Type, rhs:Self.Type) -> Bool {
//
////      let b:(GenericEquatable.protocol) = self
////      b
////      let typeself1:Self.Type = self
////
////      let typeself: Self.Type = self
////      return lhs.equals(rhs)
//
////      let c = getGeneric(lhs)
//      return lhs == rhs
//   }

//   func e(lhs:Self) -> Bool {
//      return self == lhs
//   }
//}

//extension GenericEquatable {
////   static func equalsP<Self:GenericEquatable>(lhs:Self, rhs:Self) -> Bool {
////      return lhs.equals(rhs)
////   }
//   func equals(_ obj:EquatableType) -> Bool {
//      let a:EquatableType = self
//      let b:EquatableType = obj
//
//      return self == obj
//   }
//}

//extension String : GenericEquatable {
//   typealias EquatableType = String
//}





//protocol GenericEquatable : Equatable {
//
////Equatable protocol defines == as being (Self,Self)->Bool
////This definition requires type information to be passed along since
////you cant call == on two Equatable objects unless the objects have
////the same class
////
////We need a function that explicitly requires the parameter types to be the same
////therefore we define a generic type and use a closure that takes two of those types explicitly
//
//   associatedtype EquatableType = Self
////   func equals(_ obj:EquatableType)->Bool
//   static func equals(lhs:EquatableType, rhs:EquatableType)->Bool
//   func equal(rhs:EquatableType) -> Bool
//}
//





//
//
//struct EquatableHelper<T> {
//   typealias EqualsBlock = (T, T) -> Bool
//   fileprivate var blocks = [EqualsBlock]()
//
//   mutating func append(_ equals: (T, T) -> Bool) {
////      blocks.append(equals)
//   }
//}


//
//// MARK: Any
//extension EquatableHelper {
//   mutating func append<E>(_ property: @escaping (T) -> E, equals: @escaping (E, E) -> Bool) {
//      append { equals(property($0), property($1)) }
//   }
//}
//// MARK: Equatable
//extension EquatableHelper {
//   mutating func append<E: Equatable>(_ property: @escaping (T) -> E) {
//      append(property, equals: ==)
//   }
//}
//// MARK: Optional<Equatable>
//extension EquatableHelper {
//   mutating func append<E: Equatable>(_ property: @escaping (T) -> E?) {
//      append(property, equals: ==)
//   }
//}






//
//
//func ==<T: GenericEquatable>(lhs: T, rhs: T) -> Bool where T.EquatableType == T {
////   return T.equals(lhs:lhs,rhs: rhs)
//   return lhs==rhs
//}




//extension GenericEquatable { //where EquatableType:GenericEquatable {
////   associatedtype EquatableType = Self
////   static func equals<EquatableType>(lhs:EquatableType,rhs:EquatableType, equals: (EquatableType,EquatableType)->Bool)->Bool {
////      return equals(lhs,rhs)
////
////      let a = example
////      let result = a.equals(a,a)
////   }
//
////   static func asdf<T:Equatable&Self>(lhs:T,rhs:T)->Bool {
////      return lhs == rhs
////   }
//
//   public func equalsSSS<T>(lhs:T,rhs:T,comparator: (T,T)->Bool ) -> Bool {
//      return comparator(lhs,rhs)
//   }
//
//   func equals<T: GenericEquatable>(obj:T)->Bool where T.EquatableType == T {
////      var operation:(Int, Int) -> Int = (*)
////      var operation2:(String,String)->Bool = (==)
////      var operation3:(EquatableType,EquatableType)->Bool = (==)
////
////      return equalsSSS(lhs:self,rhs:obj,comparator:==)
////
////      let equals:(EquatableType.Type,EquatableType.Type)->Bool = (==) as! (EquatableType.Type,EquatableType.Type)->Bool
//      return equalsSSS(lhs:self,rhs:obj,comparator:==)
//      return true
//   }
//}
//
//struct example : GenericEquatable {
//   typealias EquatableType = String
//}

//protocol TypedEquatableStruct {
//   associatedtype Item: Equatable
//}
