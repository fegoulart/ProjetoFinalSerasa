//
//  HomeViewControllerTests.swift
//  CatAPITests
//
//  Created by Fernando Luiz Goulart on 14/11/21.
//

import XCTest
import UIKit
import CatAPI
import CatLoader

class HomeViewControllerTests: XCTestCase {

    func test_loadCatsActions_requestCatsFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
    }

    func test_loadingCatsIndicator_isVisibleWhileLoadingCats() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeCatLoadingSuccessfully(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
    }

    func test_noCatsLoadedAlert_doesNotShowAfterLoad() {
        let alertClosure: () -> Void = { [weak self] in
            guard self != nil else { return }
            XCTFail("Alert closure should not be called")
        }

        let (sut, loader) = makeSUT(noCatsAlertAction: alertClosure)

        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingAlert, "No error alert is being presented while loading request")

        loader.completeCatLoadingSuccessfully(at: 0)

        XCTAssertFalse(sut.isShowingAlert, "No error alert is being presented while loading request")
    }

    func test_noCatsLoadedAlert_notVisibleBeforePressingButton() {

        let expect = expectation(description: "Alert Closure Expectation")
        expect.isInverted = true
        let alertClosure: () -> Void = { [weak self] in
            guard self != nil else { return }
            XCTAssert(false, "Alert should not called")
            expect.fulfill()
        }

        let (sut, loader) = makeSUT(noCatsAlertAction: alertClosure)
        sut.loadViewIfNeeded()

        loader.completeCatLoading(withError: anyNSError(), at: 0)

        waitForExpectations(timeout: 5.0)
    }

    func test_noCatsLoadedAlert_isVisibleAfterLoaderError() {

        let expect = expectation(description: "Alert Closure Expectation")
        let alertClosure: () -> Void = { [weak self] in
            guard self != nil else { return }
            XCTAssert(true, "Alert should be called")
            expect.fulfill()
        }

        let (sut, loader) = makeSUT(noCatsAlertAction: alertClosure)
        sut.loadViewIfNeeded()

        loader.completeCatLoading(withError: anyNSError(), at: 0)

        sut.pressGoButton()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    // MARK: - Helpers

    private func makeSUT(
        noCatsAlertAction: (() -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: HomeViewController,
        loader: LoaderSpy
    ) {
        let loader = LoaderSpy()
        let sut = CatUIComposer.homeViewControllerComposedWith(loader: loader, noCatsAlertAction: noCatsAlertAction)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    // Pra simplificar aqui vamos usar só o Remote
    class LoaderSpy: RemoteCatLoader {
        private var completions = [(CatLoader.Result) -> Void]()

        var loadCallCount: Int {
            return completions.count
        }

        func load(completion: @escaping (CatLoader.Result) -> Void) {
            completions.append(completion)
        }

        func completeCatLoadingSuccessfully(with cats: [Cat] = [], at index: Int) {
            completions[index](.success(cats))
        }

        func completeCatLoading(withError error: Error = anyNSError(), at index: Int) {
            completions[index](.failure(error))
        }
    }
}

private extension HomeViewController {
    var isShowingLoadingIndicator: Bool {
        return indicator.isAnimating
    }

    var isShowingAlert: Bool {
        return alert.isBeingPresented
    }

    func pressGoButton() {
        self.botaoInicio.sendActions(for: .touchUpInside)
    }
}

private extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
