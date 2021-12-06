//
//  SuggestionViewModel.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 05/12/21.
//

import Foundation
import CatLoader

final class SuggestionViewModel {
    var breeds: [Cat]

    init(breeds: [Cat]) {
        self.breeds = breeds
    }

    var onBreedsFiltered: (([Cat]) -> Void)?

    func setUserWish(_ userWish: Suggestion) {
        guard let onFiltered = onBreedsFiltered else { return }
        let suggestions = FilterBreed.getSuggestions(breeds: self.breeds, wish: userWish)
        onFiltered(suggestions)
    }
}

protocol SuggestionView {
    func canDisplayNextView(bestCatViewController: BestCatsViewController)
}

final class SuggestionPresenter {
    var suggestionView: SuggestionView?
    private var breeds: [Cat]
    private var imageLoader: CatImageDataLoader

    init(breeds: [Cat], imageLoader: CatImageDataLoader) {
        self.breeds = breeds
        self.imageLoader = imageLoader
    }

    func filter(accordingTo userWish: Suggestion) {
        let suggestions = FilterBreed.getSuggestions(breeds: self.breeds, wish: userWish)
        suggestionView?.canDisplayNextView(
            bestCatViewController: CatUIComposer.catComposedWith(
                suggestions: suggestions,
                imageLoader: self.imageLoader
            )
        )
    }
}
