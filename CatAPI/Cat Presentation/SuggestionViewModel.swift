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
