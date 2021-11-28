//
//  CatImageDataLoader.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 28/11/21.
//

import Foundation

public protocol CatImageDataLoader {
    func loadImageData(from url: URL) -> CatImageDataLoaderTask
}

public protocol CatImageDataLoaderTask {
    func cancel()
}
