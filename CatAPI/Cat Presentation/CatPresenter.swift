//
//  CatPresenter.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 06/12/21.
//

import Foundation
import CatLoader

// Protocols referencing the view (HomeView in this project)
protocol CatLoadingView: AnyObject {
    func display(isLoading: Bool)
}

// TODO: Need to refactor to save allBreeds in a repository and delete this protocol
protocol CatView: AnyObject {
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

    weak var catView: CatView?
    weak var loadingView: CatLoadingView?

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
