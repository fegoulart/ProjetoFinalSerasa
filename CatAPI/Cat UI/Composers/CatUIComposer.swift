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

    public static func catComposedWith(
        userWish: Suggestion,
        imageLoader: CatImageDataLoader
    ) -> BestCatsViewController {
        let presenter = BestCatPresenter(catLoader: LocalCatLoader())
        let bestCatController = BestCatsViewController(presenter: presenter, userWish: userWish)
        presenter.bestCatView = BestCatViewAdapter(controller: bestCatController, imageLoader: ImageLoader())
        return bestCatController
    }

    public static func suggestionsComposedWith(
        allBreeds: [Cat],
        imageLoader: CatImageDataLoader
    ) -> SuggestionViewController {
        let presenter = SuggestionPresenter(breeds: allBreeds, imageLoader: imageLoader)
        let suggestionViewController = SuggestionViewController(presenter: presenter)
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

    private weak var controller: BestCatsViewController?
    private let imageLoader: CatImageDataLoader

    init(controller: BestCatsViewController, imageLoader: CatImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: BestCatsViewModel) {
        controller?.tableModel = viewModel.cats.map { model in
            CatCellController(
                viewModel: CatImageViewModel(
                    model: model,
                    imageLoader: imageLoader,
                    imageTransformer:
                        UIImage.init
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

extension WeakRefVirtualProxy: CatLoadingView where T: CatLoadingView {
    func display(_ viewModel: CatLoadingViewModel) {
        object?.display(viewModel)
    }
}
