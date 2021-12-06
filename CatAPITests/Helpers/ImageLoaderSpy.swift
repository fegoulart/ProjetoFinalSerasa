//
//  ImageLoaderSpy.swift
//  CatAPITests
//
//  Created by Fernando Luiz Goulart on 06/12/21.
//

import CatAPI
import Foundation

class ImageLoaderSpy: CatImageDataLoader {

    typealias Result = CatImageDataLoader.Result

    private var imageRequests = [(url: URL, completion: (CatImageDataLoader.Result) -> Void)]()
    var loadedImagesURLs: [URL] {
        return imageRequests.map { $0.url }
    }
    private(set) var cancelledImageURLs = [URL]()

    private struct TaskSpy: CatImageDataLoaderTask {
        let cancelCallBack: () -> Void
        func cancel() {
            cancelCallBack()
        }
    }

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> CatImageDataLoaderTask {
        imageRequests.append((url, completion))
        return TaskSpy { [weak self] in
            self?.cancelledImageURLs.append(url)
        }
    }

    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }

    func completeImageLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        imageRequests[index].completion(.failure(error))
    }
}
