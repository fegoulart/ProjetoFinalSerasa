//
//  ImageLoader.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 28/11/21.
//

import Foundation

class ImageLoaderTask: CatImageDataLoaderTask {
    func cancel() {

    }
}

public class ImageLoader: CatImageDataLoader {
    public func loadImageData(from url: URL) -> CatImageDataLoaderTask {
        return ImageLoaderTask()
    }

    public func loadImageData(from url: URL) {
        //                if let data = try? Data(contentsOf: url) {
        //                    DispatchQueue.global(qos: .background).async {
        //                        let image = UIImage(data: data)
        //                        DispatchQueue.main.async {
        //                            let cell = self.suggestionsTableView.cellForRow(at: indexPath)
        //                            var content = cell?.defaultContentConfiguration()
        //                            content?.imageProperties.reservedLayoutSize = CGSize(width: 50.0, height: 50.0)
        //                            content?.imageProperties.maximumSize = CGSize(width: 50.0, height: 50.0)
        //                            content?.image = image
        //                            if let texto = cat.name {
        //                                content?.text = texto
        //                            }
        //                            cell?.contentConfiguration = content
        //                        }
        //                    }
        //                }
    }

    public func cancelImageDataLoad(from url: URL) {
        
    }
}
