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
        bestCatViewController.suggestions = suggestions.map { cat in
            return CatCellController(model: cat, imageLoader: imageLoader)
        }
        return bestCatViewController
    }
}
