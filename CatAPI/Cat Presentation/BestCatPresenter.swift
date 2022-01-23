//
//  BestCatPresenter.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 06/12/21.
//

import Foundation
import CatLoader

struct BestCatsViewModel {
    let cats: [Cat]
}

protocol BestCatView {
    func display(_ viewModel: BestCatsViewModel)
}

final class BestCatPresenter {

    var bestCatView: BestCatView?
    var catLoader: RemoteCatLoader

    init(catLoader: RemoteCatLoader = LocalCatLoader()) {
        self.catLoader = catLoader
    }

    func loadCats(userWish: Suggestion) {

        catLoader.load { [weak self] result in
            guard let self = self, let cats = try? result.get() else {
                return
            }
            let filteredCats = self.filter(cats, accordingTo: userWish)
            let viewModel = BestCatsViewModel(cats: filteredCats)
            self.bestCatView?.display(viewModel)
        }
    }

    func filter(_ breeds: [Cat], accordingTo userWish: Suggestion) -> [Cat] {
        let suggestions = FilterBreed.getSuggestions(breeds: breeds, wish: userWish)
        return suggestions
    }
}
