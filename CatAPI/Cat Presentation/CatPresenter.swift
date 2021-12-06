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
    typealias Observer<T> = (T) -> Void

    private var catLoader: RemoteCatLoader

    init(catLoader: RemoteCatLoader) {
        self.catLoader = catLoader
    }

    // Composition details must not leak into our class
    // So, dont use weak here
    var catView: CatView?
    var loadingView: CatLoadingView?

    func loadBreeds() {
        loadingView?.display(isLoading: true)
        catLoader.load { [weak self] result  in
            if let breeds = try? result.get() {
                // TODO: Refactor to save allBreeds in a repository
                self?.catView?.canDisplayNextView(
                    suggestionViewController: CatUIComposer.suggestionsComposedWith(
                        allBreeds: breeds
                    )
                )
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
