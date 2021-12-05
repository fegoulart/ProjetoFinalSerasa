//
//  CatImageViewController.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 05/12/21.
//

import Foundation
import CatLoader
import UIKit

final class CatImageCellController {
    private var task: CatImageDataLoaderTask?
    private var model: Cat
    private var imageLoader: CatImageDataLoader

    init(model: Cat, imageLoader: CatImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }

    func view() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = model.name
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.startShimmering()
        if let imageURL = model.imageUrl {
            if let url = URL(string: imageURL) {
                let loadImage = { [weak self, weak cell] in
                    guard let self = self else { return }
                    self.task = self.imageLoader.loadImageData(from: url) { [weak cell] result in
                        let data = try? result.get()
                        let image = data.map(UIImage.init) ?? nil
                        cell?.imageView?.image = image
                        cell?.imageView?.stopShimmering()
                    }
                }
                loadImage()
            }
        } else {
            // TODO: Send this ELSE logic to imageLoader
            var content = cell.defaultContentConfiguration()
            content.imageProperties.reservedLayoutSize = CGSize(width: 50.0, height: 50.0)
            content.imageProperties.maximumSize = CGSize(width: 50.0, height: 50.0)
            content.image = UIImage(named: "cat")
            if let texto = self.model.name {
                content.text = texto
            }
            cell.contentConfiguration = content
            cell.stopShimmering()
        }
        return cell
    }

    func preload() {
        if let imageURL = model.imageUrl, let url = URL(string: imageURL) {
            task = imageLoader.loadImageData(from: url) { _ in }
        }
    }

    deinit {
        task?.cancel()
    }
}

