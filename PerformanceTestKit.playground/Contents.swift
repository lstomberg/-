//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import PerformanceTestKit

let name="Store"
let module = Module(name:"Lucas",segment:"none")


//let y: Optional<String?> = Optional(nil)
//
//var array: [String?] = ["asdf",nil]
//let val = array.first { $0 == "ewt" }
//val
//let n: String? = nil
//let o: String?? = nil
//
//let a = (nil == n)
//let b = (n == nil)
//
//let p: String?? = nil
//a
//
//
//func oo(vard: String??){
//   print(vard)
////   print(type(of: vard))
//}
//
//
//let d: Array<String> = [String]()
//
//oo(vard:nil)
//oo(vard:n)
//oo(vard: o)
//
//let onil:String?? = Optional(nil)
//print(onil)
//
//let onil2:String?? = nil
//print(onil2)
//
//let nn:String?? = o
//if nn == nil {
//   print("HI")
//} else {
//   print("WOO")
//}

//array.append(n)
//array.append(o)


//Task(named: name, in: module)
//PerformanceLog.default.data.runningTasks

try? PerformanceLog.default.startTask(named: name, inModule: module)
try? PerformanceLog.default.endTask(inModule: module, named: name, storingParition: "3")

try? PerformanceLog.default.startTask(named: name, inModule: module)
try? PerformanceLog.default.endTask(inModule: module, named: name, storingParition: "6")

try? PerformanceLog.default.startTask(named: name, inModule: Module(name:"James",segment:nil))
try? PerformanceLog.default.endTask(inModule: Module(name:"James",segment:nil), named: name, storingParition: "13")

try? PerformanceLog.default.startTask(named: name, inModule: Module(name:"Lucas",segment:nil))
try? PerformanceLog.default.endTask(inModule: Module(name:"Lucas",segment:nil), named: name, storingParition: "18")

try? PerformanceLog.default.startTask(named: name+"a", inModule: Module(name:"Lucas",segment:nil))
try? PerformanceLog.default.endTask(inModule: Module(name:"Lucas"), named: name+"a", storingParition: "18")

PerformanceLog.default.data.completedTasks
let report = PerformanceLog.default.report()

report.tasks
report.inModule

let desc = report.debugDescription
print(desc)

//PerformanceLog.default.data.runningTasks
//PerformanceLog.default.data.completedTasks

//let dispatchQueue = DispatchQueue(label: "testQueue")
//
//dispatchQueue.asyncAfter(deadline: .now() + 2) {
//   PerformanceLog.default.data.runningTasks
//   try? PerformanceLog.default.endTask(inModule: Module(name:"Lucas",segment:"none"), named: "Store")
//   PerformanceLog.default.data.runningTasks
//   PerformanceLog.default.data.completedTasks
//
//   let rpt = PerformanceLog.default.report()
//   rpt.tasks
//   print(rpt.description)
//   PlaygroundPage.current.finishExecution()
//}
//
//PlaygroundPage.current.needsIndefiniteExecution = true

