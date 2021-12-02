//
//  BestCatsViewControllerTests.swift
//  CatAPITests
//
//  Created by Fernando Luiz Goulart on 21/11/21.
//

import XCTest
import CatAPI
import UIKit
import CatLoader

class BestCatsViewControllerTests: XCTestCase {

    func test_init_noCatsRendered() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.numberOfRenderedCats(), 0)
    }

    func test_init_renderOneCatSuccessfully() {
        let cat0 = makeCat(name: "a name", imageUrl: "https://any-url.com")
        let (sut, _) = makeSUT(cats: [cat0])

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [cat0])
    }

    func test_init_renderCatsSuccessfully() {
        let cat0 = makeCat(name: "a name", imageUrl: "https://any-url.com")
        let cat1 = makeCat(name: "another name", imageUrl: "https://another-url.com")
        let cat2 = makeCat(name: "Nenúfaro", imageUrl: "http://www.nenus.com")
        let (sut, _) = makeSUT(cats: [cat0, cat1, cat2])

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [cat0, cat1, cat2])
    }

    func test_catImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let cat0 = makeCat(name: "a name", imageUrl: "https://any-url.com")
        let cat1 = makeCat(name: "another name", imageUrl: "https://another-url.com")
        let (sut, imageLoader) = makeSUT(cats: [cat0, cat1])
        sut.loadViewIfNeeded()
        XCTAssertEqual(
            imageLoader.cancelledImageURLs,
    [],
            "Expected no cancelled image URL requests until image is not visible")

        sut.simulateCatImageViewNotVisible(at: 0)
        let cat0ImageUrl = URL(string: cat0.imageUrl!)
        XCTAssertEqual(imageLoader.cancelledImageURLs, [cat0ImageUrl])

        sut.simulateCatImageViewNotVisible(at: 1)
        let cat1ImageUrl = URL(string: cat1.imageUrl!)
        XCTAssertEqual(imageLoader.cancelledImageURLs, [cat0ImageUrl, cat1ImageUrl])

    }

    // Se estivessemos carregando os dados e tambem as imagens na mesma tela, deveriamos testar se alguma imagem é carregada antes de que as celulas estejam visiveis

//    func test_catImageView_loadsImageURLWhenVisible() {
//        let cat0 = makeCat(name: "Fifi", imageUrl: "https://url-0.com")
//        let (sut) = makeSUT(cats: [cat0])
//        sut.loadViewIfNeeded()
//        sut.simulateCatImageViewVisible(at: 0)
//    }

    func test_catImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let cat0 = makeCat(name: "Joseph", imageUrl: "https://any-url.com")
        let cat1 = makeCat(name: "Manuel", imageUrl: "https://another-url.com")

        let (sut, loader) = makeSUT(cats: [cat0, cat1])
        let view0 = sut.simulateCatImageViewVisible(at: 0)
        let view1 = sut.simulateCatImageViewVisible(at: 1)
        XCTAssertEqual(
            view0?.isShowingImageLoadingIndicator,
            true,
            "Expected loading indicator for first view while loading first image"
        )
        XCTAssertEqual(
            view1?.isShowingImageLoadingIndicator,
            true,
            "Expected loading indicator for second view while loading second image"
        )

        loader.completeImageLoading(at: 0)
        XCTAssertEqual(
            view0?.isShowingImageLoadingIndicator,
            false,
            "Expected no loading indicator for view once first image loading completes successfully"
        )
        XCTAssertEqual(
            view1?.isShowingImageLoadingIndicator,
            true,
            "Expected no loading indicator state change for second view once first image loading completes successfully"
        )
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(
            view0?.isShowingImageLoadingIndicator,
            false,
            "Expected no loading indicator for view once second image loading completes with error"
        )
        XCTAssertEqual(
            view1?.isShowingImageLoadingIndicator,
            false,
            "Expected no loading indicator for second view once second image loading completes with error"
        )

    }

    func test_catImageView_rendersImageLoadedFromURL() {
        let cat0 = makeCat(name: "Joseph", imageUrl: "https://any-url.com")
        let cat1 = makeCat(name: "Manuel", imageUrl: "https://another-url.com")

        let (sut, loader) = makeSUT(cats: [cat0, cat1])
        let view0 = sut.simulateCatImageViewVisible(at: 0)
        let view1 = sut.simulateCatImageViewVisible(at: 1)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading second image")

        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(
            view0?.renderedImage,
            imageData0,
            "Expected image for first view once first image loading completes successfully"
        )
        XCTAssertEqual(
            view1?.renderedImage,
                .none,
            "Expected no image state change for second view once first image loading completes successfully"
        )

        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(
            view0?.renderedImage,
            imageData0,
            "Expected no image state change for first view once second image loading completes successfully"
        )
        XCTAssertEqual(
            view1?.renderedImage,
            imageData1,
            "Expected image for second view once second image loading completes successfully"
        )
    }

    func test_catImageView_preloadsImageURLWhenNearVisible() {
        let cat0 = makeCat(name: "Joseph", imageUrl: "https://any-url.com")
        let cat1 = makeCat(name: "Manuel", imageUrl: "https://another-url.com")
        let (sut, loader) = makeSUT(cats: [cat0, cat1])
        guard let image0 = URL(string: cat0.imageUrl!) else {
            XCTFail("cat0 should have a valid imageURL")
            return
        }
        guard let image1 = URL(string: cat1.imageUrl!) else {
            XCTFail("cat1 should have a valid imageURL")
            return
        }

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadedImagesURLs, [])

        sut.simulateCatImageViewNearVisible(at: 0)
        XCTAssertEqual(
            loader.loadedImagesURLs,
            [image0],
            "Expected first image URL request once first image is near visible"
        )
        sut.simulateCatImageViewNearVisible(at: 1)
        XCTAssertEqual(
            loader.loadedImagesURLs,
            [image0, image1],
            "Expected first image URL request once first image is near visible"
        )
    }

    func test_catImageView_cancelsImageURLPreloadingWhenNotNearVisible() {
        let cat0 = makeCat(name: "Joseph", imageUrl: "https://any-url.com")
        let cat1 = makeCat(name: "Manuel", imageUrl: "https://another-url.com")
        let (sut, loader) = makeSUT(cats: [cat0, cat1])
        guard let image0 = URL(string: cat0.imageUrl!) else {
            XCTFail("cat0 should have a valid imageURL")
            return
        }
        guard let image1 = URL(string: cat1.imageUrl!) else {
            XCTFail("cat1 should have a valid imageURL")
            return
        }

        sut.loadViewIfNeeded()
        XCTAssertEqual(
            loader.cancelledImageURLs,
    [],
            "Expected no cancelled image URL requests until is not near visible"
        )

        sut.simulateCatImageViewNotNearVisible(at: 0)
        XCTAssertEqual(
            loader.cancelledImageURLs,
            [image0],
            "Expected first cancelled image URL request once first image is not near visible anymore"
        )
        sut.simulateCatImageViewNotNearVisible(at: 1)
        XCTAssertEqual(
            loader.cancelledImageURLs,
            [image0, image1],
            "Expected second cancelled image URL request once second image is not near visible anymore"
        )
    }

    // Helper

    private func makeSUT(cats: [Cat] = []) -> (BestCatsViewController, ImageLoaderSpy) {
        let imageLoader = ImageLoaderSpy()
        let mViewController = BestCatsViewController(suggestions: cats, imageLoader: imageLoader)
        return (mViewController, imageLoader)
    }

    // Pra simplificar aqui vamos usar só o Remote
    class ImageLoaderSpy: CatImageDataLoader {

        typealias Result = CatImageDataLoader.Result

        private var imageRequests = [(url: URL, completion: (CatImageDataLoader.Result) -> Void)]()
        var loadedImagesURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        private(set) var cancelledImageURLs = [URL]()

        private struct TaskSpy: CatImageDataLoaderTask {
            let cancelCallBack: () -> Void
            func cancel() {
                cancelCallBack()
            }
        }

        func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> CatImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in
                self?.cancelledImageURLs.append(url)
            }
        }

        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }

        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }

    private func makeCat(name: String, imageUrl: String) -> Cat {
        return Cat(
            adaptability: nil,
            hypoallergenic: nil,
            identity: nil,
            imageUrl: imageUrl,
            indoor: nil,
            intelligence: nil,
            lap: nil,
            lifeSpan: nil,
            name: name,
            natural: nil,
            origin: nil,
            rare: nil,
            rex: nil,
            sheddingLevel: nil,
            shortLegs: nil,
            socialNeeds: nil,
            strangerFriendly: nil,
            suppressedTail: nil,
            temperament: nil,
            vocalisation: nil,
            weight: nil,
            affectionLevel: nil,
            catDescription: nil
        )
    }

    private func assertThat(
        _ sut: BestCatsViewController,
        isRendering cats: [Cat],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard sut.numberOfRenderedCats() == cats.count else {
            return XCTFail(
                "Expected \(cats.count) cats, got \(sut.numberOfRenderedCats()) instead", file: file, line: line)
        }
        cats.enumerated().forEach { index, cat in
            assertThat(sut, hasViewConfiguredFor: cat, at: index, file: file, line: line)
        }
    }

    private func assertThat(
        _ sut: BestCatsViewController,
        hasViewConfiguredFor cat: Cat,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let view = sut.catImageView(at: index)

        let cell = view

        XCTAssertEqual(
            cell?.nameText,
            cat.name,
            "Expected cat name to be \(cat.name ??? "") for cat at index \(index)",
            file: file,
            line: line
        )
    }
}

// DSL
private extension BestCatsViewController {

    @discardableResult
    func simulateCatImageViewVisible(at index: Int) -> UITableViewCell? {
        return catImageView(at: index)
    }

    func simulateCatImageViewNotVisible(at row: Int) {
        let view = simulateCatImageViewVisible(at: row)

        let delegate = suggestionsTableView.delegate
        let index = IndexPath(row: row, section: catsSection)
        delegate?.tableView?(suggestionsTableView, didEndDisplaying: view!, forRowAt: index)
    }

    func simulateCatImageViewNearVisible(at row: Int) {
        let mDataSource = suggestionsTableView.prefetchDataSource
        let index = IndexPath(row: row, section: catsSection)
        mDataSource?.tableView(suggestionsTableView, prefetchRowsAt: [index])
    }

    func simulateCatImageViewNotNearVisible(at row: Int) {
        simulateCatImageViewNearVisible(at: row)

        let mDataSource = suggestionsTableView.prefetchDataSource
        let index = IndexPath(row: row, section: catsSection)
        mDataSource?.tableView?(suggestionsTableView, cancelPrefetchingForRowsAt: [index])
    }

    func numberOfRenderedCats() -> Int {
        return suggestionsTableView.numberOfRows(inSection: catsSection)
    }

    func catImageView(at row: Int) -> UITableViewCell? {
        let mDataSource = suggestionsTableView.dataSource
        let index = IndexPath(row: row, section: catsSection)
        return mDataSource?.tableView(suggestionsTableView, cellForRowAt: index)
    }

    private var catsSection: Int {
        return 0
    }
}

// DSL for Cell
private extension UITableViewCell {
    var nameText: String? {
        return textLabel?.text
    }

    var isShowingImageLoadingIndicator: Bool {
        return self.imageView?.isShimmering ?? false
    }

    var renderedImage: Data? {
        return self.imageView?.image?.pngData()
    }
}

private extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
