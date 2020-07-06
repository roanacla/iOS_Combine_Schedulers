import Combine
import SwiftUI
import PlaygroundSupport

let source = Timer
  .publish(every: 1.0, on: .main, in: .common)
  .autoconnect()
  .scan(0) { counter, _ in counter + 1 }

// 1
let setupPublisher = { recorder in
  source
    // 2
    .recordThread(using: recorder)
    // 3
    .receive(on: ImmediateScheduler.shared)//You can use this scheduler for immediate actions. If you attempt to schedule actions after a specific date, the scheduler ignores the date and executes synchronously.
    .receive(on: DispatchQueue.global())
    // 4
    .recordThread(using: recorder)
    // 5
    .eraseToAnyPublisher()
}

// 6
let view = ThreadRecorderView(title: "Using ImmediateScheduler", setup: setupPublisher)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)

//: [Next](@next)

