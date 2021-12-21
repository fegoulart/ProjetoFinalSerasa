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

    var completionHandler: ((BreedsLoadResult) -> Void)
    private var catLoader: RemoteCatLoader
    private var operationFinished = false

    init(
        catLoader: RemoteCatLoader,
        completionHandler:  @escaping (BreedsLoadResult) -> Void
    ) {
        self.catLoader = catLoader
        self.completionHandler = completionHandler
    }

    override func start() {
        loadBreeds()
    }

    override var isFinished: Bool {
        return self.operationFinished
    }

    override var isAsynchronous: Bool {
        return true
    }

    private func loadBreeds() {
        catLoader.load { [weak self] loaderResult in
            guard self != nil else { return }
            self?.completionHandler(loaderResult)
            self?.operationFinished = true
        }
    }
}
