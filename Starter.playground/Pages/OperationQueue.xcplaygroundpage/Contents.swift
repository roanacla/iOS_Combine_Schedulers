import Foundation
import Combine
import SwiftUI
import PlaygroundSupport

//OperationQueue. This system class is defined as a queue that regulates the execution of operations. It is a rich regulation mechanism that lets you create advanced operations with dependencies.
//OperationQueue executes operations concurrently by default. You need to be very aware of this as it can cause you trouble:

let queue = OperationQueue()
queue.maxConcurrentOperationCount = 1 //without this line. The publisher will put all values in the same pool at the same time ant the OperationQueue() will deliver all of them in different operations.
let subscription = (1...10).publisher
  .receive(on: queue)
  .sink { value in
    print("Received \(value) on thread \(Thread.current.number)")
  }
