import Combine
import SwiftUI
import PlaygroundSupport

//A DispatchQueue can be either serial (the default) or concurrent. A serial queue executes all the work items you feed it, in sequence. A concurrent queue will start multiple work items in parallel, to maximize CPU usage.
//DispatchQueue is the only scheduler providing a set of options you can pass when operators take a SchedulerOptions argument.


let serialQueue = DispatchQueue(label: "Serial queue")
let sourceQueue = DispatchQueue.main
//let sourceQueue = serialQueue

// 1
let source = PassthroughSubject<Void, Never>()

// 2
let subscription = sourceQueue.schedule(after: sourceQueue.now,
                                        interval: .seconds(1)) {
  source.send()
}

let setupPublisher = { recorder in
  source
    .recordThread(using: recorder)
//    .receive(on: serialQueue)
    .receive(
      on: serialQueue,
      options: DispatchQueue.SchedulerOptions(qos: .userInteractive)
    )//You don't need to setup options in the majority of cases. GCD handles very way the QOS (Quality of service). .userInteractive is high priority while .backgroud is less priority.
    .recordThread(using: recorder)
    .eraseToAnyPublisher()
}

    let view = ThreadRecorderView(title: "Using DispatchQueue",
                              setup: setupPublisher)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)
//: [Next](@next)
/*:
 Copyright (c) 2019 Razeware LLC

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 distribute, sublicense, create a derivative work, and/or sell copies of the
 Software in any work that is designed, intended, or marketed for pedagogical or
 instructional purposes related to programming, coding, application development,
 or information technology.  Permission for such use, copying, modification,
 merger, publication, distribution, sublicensing, creation of derivative works,
 or sale is expressly withheld.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

