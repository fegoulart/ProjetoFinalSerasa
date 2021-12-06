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
        let bestCatViewController = BestCatsViewController()
        adaptCatToCellControllers(forwardingTo: bestCatViewController, imageLoader: imageLoader)(suggestions)
        return bestCatViewController
    }

    public static func suggestionsComposedWith(allBreeds: [Cat]) -> SuggestionViewController {
        let suggestionViewController = SuggestionViewController()
        let viewModel = SuggestionViewModel(breeds: allBreeds)
        viewModel.onBreedsFiltered = { [weak suggestionViewController] cats in
            let imageLoader = ImageLoader()
            suggestionViewController?.bestCatsViewController = CatUIComposer.catComposedWith(
                suggestions: cats,
                imageLoader: imageLoader
            )
        }
        suggestionViewController.viewModel = viewModel
        return suggestionViewController
    }

    public static func homeViewControllerComposedWith(
        loader: RemoteCatLoader,
        noCatsAlertAction: (() -> Void)?
    ) -> HomeViewController {
        let presenter = CatPresenter(catLoader: loader)
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
    private static func adaptCatToCellControllers(
        forwardingTo controller: BestCatsViewController,
        imageLoader: CatImageDataLoader
    ) -> ([Cat]) -> Void {
        return { [weak controller] cat in
            controller?.suggestions = cat.map { model in
                let viewModel = CatImageViewModel(
                    model: model,
                    imageLoader: imageLoader,
                    imageTransformer: UIImage.init)
                viewModel.onSelected = { [weak controller] cat in
                    let localRepository = CoreDataRepository()
                    let detailViewController = DetailViewController(cat: cat, catImage: UIImage(), localRepository: localRepository)
                    controller?.detailViewController = detailViewController
                }
                return CatCellController(viewModel: viewModel)
            }

        }
    }
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
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}
