//
//  BreedsLoadOperation.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 19/12/21.
//

import Foundation
import CatLoader

final class BreedsLoadOperation: Operation {

    typealias BreedsLoadResult = Result<[Cat], Error>

    private var catLoader: RemoteCatLoader
    var breeds: [Cat] = []
    private var operationFinished = false
    private var operationExecuting = false
    private var operationCancelled = false
    private var hasFailed = false

    init(
        catLoader: RemoteCatLoader
    ) {
        self.catLoader = catLoader
    }

    override func start() {
        if !hasCancelledDependencies() {
            willChangeValue(forKey: #keyPath(isExecuting))
            self.operationExecuting = true
            didChangeValue(forKey: #keyPath(isExecuting))
            loadBreeds { [weak self] result in
                switch result {
                case .success(let cats):
                    self?.breeds = cats
                    self?.successCompletion()
                case .failure:
                    self?.cancelledCompletion()
                }
            }
        } else {
            self.cancelledCompletion()
        }
    }

    override var isExecuting: Bool {
        return self.operationExecuting
    }

    override var isFinished: Bool {
        return self.operationFinished
    }

    override var isCancelled: Bool {
        return self.operationCancelled
    }

    override var isAsynchronous: Bool {
        return true
    }

    private func loadBreeds(completion: @escaping((BreedsLoadResult) -> Void)) {
        catLoader.load { [weak self] result in
                switch result {
                case .success(let cats):
                    self?.breeds = cats
                    self?.successCompletion()
                case .failure:
                    self?.cancelledCompletion()
                }
        }
    }

    private func successCompletion() {
        willChangeValue(forKey: #keyPath(isExecuting))
        willChangeValue(forKey: #keyPath(isFinished))
        self.operationExecuting = false
        self.operationFinished = true
        didChangeValue(forKey: #keyPath(isExecuting))
        didChangeValue(forKey: #keyPath(isFinished))
    }

    private func cancelledCompletion() {
        willChangeValue(forKey: #keyPath(isExecuting))
        willChangeValue(forKey: #keyPath(isCancelled))
        willChangeValue(forKey: #keyPath(isFinished))
        self.operationExecuting = false
        self.operationCancelled = true
        self.operationFinished = true
        didChangeValue(forKey: #keyPath(isExecuting))
        didChangeValue(forKey: #keyPath(isCancelled))
        didChangeValue(forKey: #keyPath(isFinished))
    }

    private func hasCancelledDependencies() -> Bool {
        guard !dependencies.contains(where: { $0.isCancelled }), !isCancelled else {
            return true
        }
        return false
    }
}
