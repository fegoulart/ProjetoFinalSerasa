//
//  CatImageDataLoader.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 28/11/21.
//

import Foundation

public protocol CatImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> CatImageDataLoaderTask
}

public protocol CatImageDataLoaderTask {
    func cancel()
}
