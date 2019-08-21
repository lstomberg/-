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

public struct Module : Codable, Equatable {
    public let name: String
    public let segment: String?
}

public struct TaskConfiguration : Codable {
    public let name: String
    public let module: Module
    public let executionDetails: String?
}

public struct Task {
    public let configuration: TaskConfiguration
    public let startTime: Date = Date()
}

public struct Result : Codable {
    public let configuration: TaskConfiguration
    public let duration: TimeInterval
    public let partition: String?
}

extension Task {

    public func finish(_ partition: String? = nil) -> Result {
        let duration = Date().timeIntervalSince(self.startTime)
        let result = Result(configuration: self.configuration, duration: duration, partition: partition)
        return result
    }

}

extension Module {

    // swiftlint:disable identifier_name
    static func ∈(lhs:Module, rhs:Module?) -> Bool {
    // swiftlint:enable identifier_name
         guard let rhs = rhs else {
             return true
         }
         return (lhs.name == rhs.name && (rhs.segment == nil || lhs.segment == rhs.segment))
    }

}
