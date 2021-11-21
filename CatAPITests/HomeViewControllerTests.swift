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

        loader.completeCatLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
    }

    func test_noCatsLoadedAlert_doesNotShowAfterLoad() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingAlert, "No error alert is being presented while loading request")

        loader.completeCatLoading(at: 0)

        XCTAssertFalse(sut.isShowingAlert, "No error alert is being presented while loading request")
    }

    func test_noCatsLoadedAlert_isVisibleAfterLoaderError() {
        let (sut, loader) = makeSUT()
        // let container = TestingContainerViewController(sut)

        //        let window = UIWindow(frame: UIScreen.main.bounds)
        //        window.rootViewController = sut

        UIWindow(frame: UIScreen.main.bounds).rootViewController = sut
        UIWindow(frame: UIScreen.main.bounds).makeKeyAndVisible()
        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingAlert, "No error alert is being presented while loading request")

        loader.completeCatLoading(withError: anyNSError(), at: 0)
        XCTAssertFalse(sut.isShowingAlert, "No error alert is being presented while loading request")

        sut.pressGoButton()
        XCTAssertTrue(sut.isShowingAlert, "No error alert is being presented while loading request")

        //        let exp = expectation(description: "Test after 1.5 second wait")
        //        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        //        if result == XCTWaiter.Result.timedOut {
        //            XCTAssertTrue(sut.isShowingAlert, "No error alert is being presented while loading request")
        //        } else {
        //            XCTFail("Delay interrupted")
        //        }
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
        // let sut = HomeViewController(catLoader: loader)
        let sut = HomeViewController(catLoader: loader, noCatsAlertAction: noCatsAlertAction)
        // UIWindow(frame: UIScreen.main.bounds).rootViewController = sut
        // let sut = TestingHomeViewController(catLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

//    func topMostController() -> UIViewController? {
//        let keyWindow =
//        UIApplication
//            .shared
//            .connectedScenes
//            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
//            .first { $0.isKeyWindow }
//        var topController = keyWindow?.rootViewController
//
//        while (topController?.presentedViewController != nil) {
//            topController = topController?.presentedViewController!
//        }
//
//        return topController
//    }

    // Pra simplificar aqui vamos usar só o Remote
    class LoaderSpy: RemoteCatLoader {
        private var completions = [(CatLoader.Result) -> Void]()

        var loadCallCount: Int {
            return completions.count
        }

        func load(completion: @escaping (CatLoader.Result) -> Void) {
            completions.append(completion)
        }

        func completeCatLoading(at index: Int) {
            completions[index](.success([]))
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
