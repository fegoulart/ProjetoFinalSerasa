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
