//
//  MainQueueDispatchDecorator.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 21/11/21.
//

import Foundation
import CatLoader

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T

    init(decoratee: T) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
}

extension MainQueueDispatchDecorator: CatLoaderProtocol where T == CatLoader {
    func load(completion: @escaping (CatLoaderProtocol.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
