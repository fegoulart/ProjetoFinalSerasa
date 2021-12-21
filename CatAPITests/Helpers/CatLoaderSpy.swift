//
//  CatLoaderSpy.swift
//  CatAPITests
//
//  Created by Fernando Luiz Goulart on 19/12/21.
//

import Foundation
import CatLoader

final class CatLoaderSpy: RemoteCatLoader {
    typealias Result = CatLoader.Result

    private var completions: [(Result) -> Void] = []

    func load(completion: @escaping (Result) -> Void) {
        completions.append(completion)
    }

    func complete(with breeds: [Cat], at index: Int = 0) {
        completions[index](.success(breeds))
    }

    func complete(with error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }

}
