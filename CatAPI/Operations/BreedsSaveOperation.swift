//
//  BreedsSaveOperation.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 22/12/21.
//

import Foundation
import CatLoader

final class BreedsSaveOperation: Operation {

    private var operationFinished = false
    private var operationExecuting = false
    private var operationCancelled = false

    var localRepository: BreedsLocalRepository

    init(
        localRepository: BreedsLocalRepository
    ) {
        self.localRepository = localRepository
    }

    override func start() {
        if !hasCancelledDependencies() {
            guard let breedsLoadOperation = dependencies.first as? BreedsLoadOperation else {
                cancelledCompletion()
                return
            }
            willChangeValue(forKey: #keyPath(isExecuting))
            self.operationExecuting = true
            didChangeValue(forKey: #keyPath(isExecuting))
            truncateDB { [self] result in
                switch result {
                case .success:
                    saveBreeds(breeds: breedsLoadOperation.breeds) { [self] result in
                        switch result {
                        case .success:
                            successCompletion()
                        case .failure(let error):
                            print(error)
                            cancelledCompletion()
                        }
                    }
                case .failure(let error):
                    print(error)
                    cancelledCompletion()
                }
            }
        } else {
            self.cancelledCompletion()
        }
    }

    override var isCancelled: Bool {
        return self.operationCancelled
    }

    override var isFinished: Bool {
        return self.operationFinished
    }

    override var isAsynchronous: Bool {
        return true
    }

    override var isExecuting: Bool {
        return self.operationExecuting
    }

    private func truncateDB(completion: @escaping(Result<Void, LocalRepositoryError>) -> Void) {
        self.localRepository.truncateBreeds { result in
            completion(result)
        }
    }

    private func saveBreeds(breeds: [Cat], completion: @escaping(Result<Void, LocalRepositoryError>) -> Void) {
        guard breeds.count > 0 else {
            completion(.failure(.noBreedsInserted))
            return
        }
        localRepository.saveBreeds(breeds: breeds) { result in
            completion(result)
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

    deinit {
        print("Breeds Save Operation Deinit")
    }
}
