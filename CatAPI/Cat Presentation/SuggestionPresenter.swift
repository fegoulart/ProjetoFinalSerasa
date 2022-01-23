//
//  SuggestionViewModel.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 05/12/21.
//

import Foundation
import CatLoader

final class SuggestionPresenter {
    private var breeds: [Cat]
    private var imageLoader: CatImageDataLoader

    init(breeds: [Cat], imageLoader: CatImageDataLoader) {
        self.breeds = breeds
        self.imageLoader = imageLoader
    }
}
