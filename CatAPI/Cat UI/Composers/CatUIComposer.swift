//
//  CatUIComposer.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 05/12/21.
//

import Foundation
import CatLoader

public final class CatUIComposer {
    private init() {}

    public static func catComposedWith(suggestions: [Cat], imageLoader: CatImageDataLoader) -> BestCatsViewController {
        let bestCatViewController = BestCatsViewController()
        adaptCatToCellControllers(forwardingTo: bestCatViewController, imageLoader: imageLoader)(suggestions)
        return bestCatViewController
    }

    public static func suggestionsComposedWith(allBreeds: [Cat]) -> SuggestionViewController {
        let suggestionViewController = SuggestionViewController()
        suggestionViewController.suggestions = allBreeds
        return suggestionViewController
    }

    public static func homeViewControllerComposedWith(
        loader: RemoteCatLoader,
        noCatsAlertAction: (() -> Void)?
    ) -> HomeViewController {
        let homeViewController = HomeViewController()
        homeViewController.catLoader = loader
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
                CatCellController(model: model, imageLoader: imageLoader)
            }

        }
    }
}
