//
//  QueueManager.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 21/12/21.
//

import Foundation

class QueueManager {
    /// The Lazily-instantiated queue
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        return queue
    }()

    /// The Singleton Instance
    static let sharedInstance = QueueManager()

    /// Add a single operation
    /// - Parameter operation: The operation to be added
    func enqueue(_ operation: Operation) {
        queue.addOperation(operation)
    }

    /// Add an array of operations
    /// - Parameter operations: The Array of Operation to be added
    func addOperations(_ operations: [Operation]) {
        queue.addOperations(operations, waitUntilFinished: true)
    }
}
