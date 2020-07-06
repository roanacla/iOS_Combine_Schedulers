import Foundation
import Combine

// 1
let computationPublisher = Publishers.ExpensiveComputation(duration: 3)

// 2
let queue = DispatchQueue(label: "serial queue")

// 3
let currentThread = Thread.current.number
print("Start computation publisher on thread \(currentThread)")

let subscription = computationPublisher
    .subscribe(on: queue) //This line tells in which thread the process is going to run
    .receive(on: DispatchQueue.main) //This line tells in which thread you are going to receive the values
    .sink { value in
        let thread = Thread.current.number
        print("Received computation result on thread \(thread): '\(value)'")
    }

//############### OUTPUT     ########################
//Start computation publisher on thread 1
//ExpensiveComputation subscriber received on thread 6
//Beginning expensive computation on thread 6
//Completed expensive computation on thread 6
//Received computation result on thread 1: 'Computation complete'
