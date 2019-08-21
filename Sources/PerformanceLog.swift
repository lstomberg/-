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
import UIKit

//
// MARK: Class definition
//

public class PerformanceLogger {

    public static let `default` = PerformanceLogger()

    private var runningTasks: [String:Task] = [:]
    private let fileURL: URL

    private var results: [Result] = [] {
        didSet {
            save(results: results, to: fileURL)
        }
    }

    init(to fileURL: URL) {
        self.fileURL = fileURL
        self.results = loadResults(from: fileURL)
    }

    convenience init(named name: String? = nil) {
        let containerDir: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let name = name ?? "DefaultLogger"
        let filePath: String = "\(containerDir)/\(name).plist"
        let url: URL = URL(fileURLWithPath: filePath)
        self.init(to: url)
    }
}

//
// MARK: Save/Load
//

private func save(results: [Result], to url: URL) {
    try? results.encodeJSON().write(to: url)
}

private func loadResults(from url: URL) -> [Result]  {
    guard let encodedData: Data = try? Data(contentsOf: url),
        let results: [Result] = try? [Result].decode(fromJSON: encodedData) else {
            return []
    }
    return results
}

//
// MARK: Tasks
//

public struct TaskIdentifier {
    fileprivate let key: String
}

public extension PerformanceLogger {

    // MARK: PUBLIC API
    func start(_ configuration: TaskConfiguration) -> TaskIdentifier {
        let task = Task(configuration: configuration)
        let key =  UUID().uuidString
        self.runningTasks[key] = task
        return TaskIdentifier(key: key)
    }

    func end(task taskIdentifier: TaskIdentifier, partition: String? = nil) {
        guard let task: Task = self.runningTasks.removeValue(forKey: taskIdentifier.key) else {
            print("\(taskIdentifier) already finished")
            return
        }
        let result: Result = task.finish(partition)
        self.results.append(result)
    }

}

//
// MARK: Reporting
//

public extension PerformanceLogger {

    func generateReport() -> Report {
        return Report(results: self.results)
    }

}
