//
//  CatViewModel.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 05/12/21.
//

import Foundation
import CatLoader

// MVVM ViewModels must be platform agnostic.
// ViewModels should not know about UIKit
// ViewModels should not know about the Views
final class CatViewModel {
    typealias Observer<T> = (T) -> Void

    private var catLoader: RemoteCatLoader

    init(catLoader: RemoteCatLoader) {
        self.catLoader = catLoader
    }

    var onLoadingStateChange: Observer<Bool>?
    var onBreedsLoad: Observer<[Cat]>?

    func loadBreeds() {
        onLoadingStateChange?(true)
        catLoader.load { [weak self] result  in
            if let breeds = try? result.get() {
                self?.onBreedsLoad?(breeds)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
