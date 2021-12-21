//
//  CatUIComposer.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 05/12/21.
//

import Foundation
import CatLoader
import UIKit

public final class CatUIComposer {
    private init() {}

    public static func catComposedWith(suggestions: [Cat], imageLoader: CatImageDataLoader) -> BestCatsViewController {
        let presenter = BestCatPresenter()
        let bestCatController = BestCatsViewController(presenter: presenter)
        presenter.bestCatView = BestCatViewAdapter(
            cats: suggestions,
            controller: bestCatController,
            imageLoader: imageLoader
        )
        return bestCatController
    }

    public static func suggestionsComposedWith(
        allBreeds: [Cat],
        imageLoader: CatImageDataLoader
    ) -> SuggestionViewController {
        let presenter = SuggestionPresenter(breeds: allBreeds, imageLoader: imageLoader)
        let suggestionViewController = SuggestionViewController(presenter: presenter)
        presenter.suggestionView = WeakRefVirtualProxy(suggestionViewController)
        return suggestionViewController
    }

    public static func homeViewControllerComposedWith(
        loader: RemoteCatLoader,
        imageLoader: CatImageDataLoader,
        noCatsAlertAction: (() -> Void)?
    ) -> HomeViewController {
        let presenter = HomePresenter(catLoader: loader, imageLoader: imageLoader)
        let homeViewController = HomeViewController(presenter: presenter)
        presenter.loadingView = WeakRefVirtualProxy( homeViewController)
        presenter.catView = WeakRefVirtualProxy(homeViewController)
        if noCatsAlertAction == nil {
            homeViewController.noCatsAlertAction = { [weak homeViewController] in
                guard let mViewController: HomeViewController = homeViewController else { return }
                mViewController.present(mViewController.alert, animated: true, completion: nil)
            }
        } else {
            homeViewController.noCatsAlertAction = noCatsAlertAction
        }
        return homeViewController
    }

    // Adapter pattern
//    private static func adaptCatToCellControllers(
//        forwardingTo controller: BestCatsViewController,
//        imageLoader: CatImageDataLoader
//    ) -> ([Cat]) -> Void {
//        return { [weak controller] cat in
//            controller?.suggestions = cat.map { model in
//                let viewModel = CatImageViewModel(
//                    model: model,
//                    imageLoader: imageLoader,
//                    imageTransformer: UIImage.init)
//                viewModel.onSelected = { [weak controller] cat in
//                    let localRepository = CoreDataRepository()
//                    let detailViewController = DetailViewController(
//                        cat: cat,
//                        catImage: UIImage(),
//                        localRepository: localRepository
//                    )
//                    controller?.detailViewController = detailViewController
//                }
//                return CatCellController(viewModel: viewModel)
//            }
//
//        }
//    }
}

private final class BestCatViewAdapter: BestCatView {
    func display(_ viewModel: BestCatsViewModel) {
    }

    private weak var controller: BestCatsViewController?
    private let imageLoader: CatImageDataLoader
    private let cats: [Cat]

    init(cats: [Cat], controller: BestCatsViewController, imageLoader: CatImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.cats = cats
    }

    func display() {
        controller?.suggestions = self.cats.map { model in
            CatCellController(
                viewModel: CatImageViewModel(
                    model: model,
                    imageLoader: imageLoader,
                    imageTransformer: UIImage.init
                )
            )
        }
    }

//    private static func adaptCatToCellControllers(
//        forwardingTo controller: BestCatsViewController,
//        imageLoader: CatImageDataLoader
//    ) -> ([Cat]) -> Void {
//        return { [weak controller] cat in
//            controller?.suggestions = cat.map { model in
//                CatCellController(
//                    viewModel: CatImageViewModel(
//                        model: model,
//                        imageLoader: imageLoader,
//                        imageTransformer: UIImage.init
//                    )
//                )
//            }
//        }
//    }
}

// Keeps a weak reference to the object and passes the messages forward
private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: CatView where T: CatView {
    func canDisplayNextView(suggestionViewController: SuggestionViewController) {
        object?.canDisplayNextView(suggestionViewController: suggestionViewController)
    }
}

extension WeakRefVirtualProxy: CatLoadingView where T: CatLoadingView {
    func display(_ viewModel: CatLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: SuggestionView where T: SuggestionView {
    func canDisplayNextView(bestCatViewController: BestCatsViewController) {
        object?.canDisplayNextView(bestCatViewController: bestCatViewController)
    }
}
