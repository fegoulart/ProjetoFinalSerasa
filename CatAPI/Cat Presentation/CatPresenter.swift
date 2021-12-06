//
//  CatPresenter.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 06/12/21.
//

import Foundation
import CatLoader

// Protocols referencing the view (HomeView in this project)
protocol CatLoadingView {
    func display(isLoading: Bool)
}

// TODO: Need to refactor to save allBreeds in a repository and delete this protocol
protocol CatView  {
    func canDisplayNextView(suggestionViewController: SuggestionViewController)
}

// Refactored from CatViewModel is very simple
// Presenter must have a reference to the View via a protocol
final class CatPresenter {

    private var catLoader: RemoteCatLoader
    private var imageLoader: CatImageDataLoader

    init(catLoader: RemoteCatLoader, imageLoader: CatImageDataLoader) {
        self.catLoader = catLoader
        self.imageLoader = imageLoader
    }

    // Composition details must not leak into our class
    // So, dont use weak here
    var catView: CatView?
    var loadingView: CatLoadingView?

    func loadBreeds() {
        loadingView?.display(isLoading: true)
        catLoader.load { [weak self] result  in
            if let breeds = try? result.get(), let imgLoader = self?.imageLoader {
                // TODO: Refactor to save allBreeds in a repository
                self?.catView?.canDisplayNextView(
                    suggestionViewController: CatUIComposer.suggestionsComposedWith(
                        allBreeds: breeds,
                        imageLoader: imgLoader
                    )
                )
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
