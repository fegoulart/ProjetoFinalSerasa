//
//  CatPresenter.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 06/12/21.
//

import Foundation
import CatLoader

struct CatLoadingViewModel {
    let isLoading: Bool
    let breeds: [Cat]
}

// Protocols referencing the view (HomeView in this project)
protocol CatLoadingView {
    func display(_ viewModel: CatLoadingViewModel)
}

enum HomePresenterError: Error {
    case noCatsFound
    case loadCatsError
}

// Refactored from CatViewModel is very simple
// Presenter must have a reference to the View via a protocol
final class HomePresenter {

    private var catLoader: CatLoaderProtocol
    private var imageLoader: CatImageDataLoader

    init(catLoader: CatLoaderProtocol, imageLoader: CatImageDataLoader) {
        self.catLoader = catLoader
        self.imageLoader = imageLoader
    }

    // Composition details must not leak into our class
    // So, dont use weak here
    var loadingView: CatLoadingView?

    func loadBreeds() {
        loadingView?.display(CatLoadingViewModel(isLoading: true, breeds: []))
        catLoader.load { [weak self] result  in
            guard let self = self else { return }
            if let breeds = try? result.get() {
                self.loadingView?.display(CatLoadingViewModel(isLoading: false, breeds: breeds))
            } else {
                self.loadingView?.display(CatLoadingViewModel(isLoading: false, breeds: []))
            }
        }
    }
}
