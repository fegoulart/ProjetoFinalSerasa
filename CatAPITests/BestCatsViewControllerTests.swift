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

    // Helper

    private func makeSUT(cats: [Cat] = []) -> (BestCatsViewController, ImageLoaderSpy) {
        let imageLoader = ImageLoaderSpy()
        let mViewController = BestCatsViewController(suggestions: cats, imageLoader: imageLoader)
        return (mViewController, imageLoader)
    }

    // Pra simplificar aqui vamos usar só o Remote
    class ImageLoaderSpy: CatImageDataLoader {

        private(set) var loadedImagesURLs = [URL]()

        private(set) var cancelledImageURLs = [URL]()

        func loadImageData(from url: URL) {
            loadedImagesURLs.append(url)
        }

        func cancelImageDataLoad(from url: URL) {
            cancelledImageURLs.append(url)
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
}
