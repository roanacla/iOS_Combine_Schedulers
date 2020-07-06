import Combine
import SwiftUI
import PlaygroundSupport

//Note: Nowadays RunLoop is a less useful class, as DispatchQueue is a sensible choice in most situations. This said, there are still some specific cases where run loops are useful. For example, Timer schedules itself on a RunLoop.
let source = Timer
  .publish(every: 1.0, on: .main, in: .common)
  .autoconnect()
  .scan(0) { (counter, _) in counter + 1 }
 
var threadRecorder: ThreadRecorder? = nil


let setupPublisher = { recorder in
  source
    // 1
//    .subscribe(on: DispatchQueue.global()) //If you use subscribe, it will subscribe to the current thread. Which it will be thread 1 because in this thread is running the app.
    .receive(on: DispatchQueue.global()) // here, is going to receive the values in any thread from Global.
    .handleEvents(receiveSubscription: { _ in threadRecorder = recorder })
    .recordThread(using: recorder)
    // 2
    .receive(on: RunLoop.current) //Because the clousure is called by ThreadRecorderView (see bellow), RunLoop curret is the main thread (Thread 1)
    .recordThread(using: recorder)
    .eraseToAnyPublisher()
}

let view = ThreadRecorderView(title: "Using RunLoop", setup: setupPublisher)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)


RunLoop.current.schedule(
    after: .init(Date(timeIntervalSinceNow: 4.5)),
    tolerance: .milliseconds(500)) {
        threadRecorder?.subscription?.cancel()
}

//One particular pitfall to avoid is using RunLoop.current in code executing on a DispatchQueue. This is because DispatchQueue threads can be ephemeral, which makes them nearly impossible to rely on with RunLoop.
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

