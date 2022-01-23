//
//  LocalCatLoader.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 23/01/22.
//

import Foundation
import CatLoader

final class LocalCatLoader: RemoteCatLoader {

    let repository: BreedsLocalRepository?

    init(repository: BreedsLocalRepository = CoreDataRepository()) {
        self.repository = repository
    }

    func load(completion: @escaping (RemoteCatLoader.Result) -> Void) {
        guard let mRepository = repository else { completion(.failure(LocalRepositoryError.retrievalError))
            return
        }
        mRepository.retrieveBreeds { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let cats):
                completion(.success(cats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
