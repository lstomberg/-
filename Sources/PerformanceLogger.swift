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

    /// shared logger
    public static let `default` = PerformanceLogger()

    private var runningTasks: [String: Task] = [:]
    private let fileURL: URL

    private var results: [Result] = [] {
        // automatic serialization to disk
        didSet { save(results: results, to: fileURL) }
    }

    init(to fileURL: URL) {
        self.fileURL = fileURL
        self.results = loadResults(from: fileURL)
    }

    convenience init(named name: String = "DefaultLogger") {
        let url = file(forLoggerNamed: name)
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

private func file(forLoggerNamed name: String) -> URL {
    let containerDir: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let filePath: String = "\(containerDir)/\(name).plist"
    let url: URL = URL(fileURLWithPath: filePath)
    return url
}

//
// MARK: Tasks management
//

/// Opaque token for a task to be referenced externally
public struct TaskIdentifier {
    fileprivate let key: String
}

public extension PerformanceLogger {

    // MARK: PUBLIC API
    func start(_ configuration: TaskConfiguration) -> TaskIdentifier {
        let task = Task(configuration: configuration)
        let key = UUID().uuidString
        self.runningTasks[key] = task
        return TaskIdentifier(key: key)
    }

    func end(task taskIdentifier: TaskIdentifier, additionalClassification: String = Result.NoAdditionalClassification) {
        guard let task: Task = self.runningTasks.removeValue(forKey: taskIdentifier.key) else {
            print("Unable to end task with identifier \(taskIdentifier.key).")
            return
        }

        let result: Result = task.finish(additionalClassification)
        self.results.append(result)
    }

}

//
// MARK: Reporting
//

public extension PerformanceLogger {
    var currentReport: String {
        return ResultTree(from: results).description
    }
}


//
// MARK: ObjC API
//

@objc(PTKObjCAPI)
internal class ObjCAPI: NSObject {

    // Keep this internal but copy what would be the generated interface to the ObjC
    // source code included in this framework so it can access these APIs
    @objc
    public static func TICK(name: String, activity: String, section: String?) {
        let section = section ?? Activity.NoSection
        let activity = Activity(name: activity, section: section)
        let task = TaskConfiguration(name: name, activity: activity)
        let identifier = TaskIdentifier(activity: activity, name: name)
        try? PerformanceLogger.default.start(task, identifier: identifier) // TODO: should probably expose exception to objc somehow
    }

    @objc
    public static func TOCK(name: String, activity: String, section: String?, additionalClassification: String?) {
        let section = section ?? Activity.NoSection
        let activity = Activity(name: activity, section: section)
        let identifier = TaskIdentifier(activity: activity, name: name)
        let additionalClassification = additionalClassification ?? Result.NoAdditionalClassification
        PerformanceLogger.default.end(task: identifier, additionalClassification: additionalClassification)
    }
}

// convenience init for creating task identifier from activity/section/name strings
fileprivate extension TaskIdentifier {
    init(activity: Activity, name: String) {
        self.key = "\(activity.name)_\(activity.section)_\(name)"
    }
}

// private extension allowing external determination of identifier
// used to allow ObjC interop without having to store identifiers everywhere
fileprivate extension PerformanceLogger {

    enum PerformanceLoggerError: Error {
        case taskAlreadyRunning(message: String)
    }

    // private API for ObjC bridging
    func start(_ configuration: TaskConfiguration, identifier: TaskIdentifier) throws {
        guard self.runningTasks[identifier.key] == nil else {
            throw PerformanceLoggerError.taskAlreadyRunning(message: "Duplicate task already started: \(identifier.key)")
        }

        let task = Task(configuration: configuration)
        self.runningTasks[identifier.key] = task
    }
}
