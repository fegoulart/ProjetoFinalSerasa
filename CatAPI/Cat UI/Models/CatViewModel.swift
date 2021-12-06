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

    var onChange: ((CatViewModel) -> Void)?
    var onBreedsLoad: (([Cat]) -> Void)?

    private(set) var isLoading: Bool = false {
        didSet {
            onChange?(self)
        }
    }

    func loadBreeds() {
        isLoading = true
        catLoader.load { [weak self] result  in
            if let breeds = try? result.get() {
                self?.onBreedsLoad?(breeds)
            }
            self?.isLoading = false
        }
    }
}
