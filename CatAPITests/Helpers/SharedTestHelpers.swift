//
//  SharedTestHelpers.swift
//  CatAPITests
//
//  Created by Fernando Luiz Goulart on 14/11/21.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
