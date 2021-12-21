//
//  XCTestCase+CatLoader.swift
//  CatAPITests
//
//  Created by Fernando Luiz Goulart on 19/12/21.
//

import XCTest
import CatLoader

extension XCTestCase {
    func expect(
    _ sut: RemoteCatLoader,
    toRetrieve expectedResult: Result<[Cat], Error>,
    file: StaticString = #file,
    line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for breeds retrieval")
        sut.load { loadResult in
            switch (expectedResult, loadResult) {
            case let (.success(expected), .success(retrieved)):
                XCTAssertEqual(retrieved, expected, file: file, line: line)
            default:
                XCTFail("Expected to load \(expectedResult), got\(expectedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
