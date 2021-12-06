//
//  CatImageViewModel.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 05/12/21.
//

import Foundation
import CatLoader

final class CatImageViewModel<Image> {
    typealias Observer<T> = (T) -> Void

    private var task: CatImageDataLoaderTask?
    private let model: Cat
    private let imageLoader: CatImageDataLoader
    private let imageTransformer: (Data) -> Image?

    init(model: Cat, imageLoader: CatImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }

    var name: String? {
        return model.name
    }

    var onImageLoad: Observer<Image>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onSelected: ((Cat) -> Void)?

    func loadImageData() {
        onImageLoadingStateChange?(true)
        if let imageURL = model.imageUrl, let url = URL(string: imageURL) {
            task = self.imageLoader.loadImageData(from: url) { [weak self] result in
                self?.handle(result)
            }
        }
    }

    private func handle(_ result: CatImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?(image)
        }
        onImageLoadingStateChange?(false)
    }

    func cancelImageDataLoad() {
        task?.cancel()
    }

    func select() {
        self.onSelected?(model)
    }
}
