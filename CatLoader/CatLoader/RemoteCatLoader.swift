//
//  CatLoader.swift
//  CatLoader
//
//  Created by Fernando Luiz Goulart on 14/11/21.
//

import Foundation

public protocol CatLoaderProtocol {
    typealias Result = Swift.Result<[Cat], Error>

    func load(completion: @escaping (Result) -> Void)
}
