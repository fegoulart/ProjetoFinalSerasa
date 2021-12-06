//
//  CatImageViewController.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 05/12/21.
//

import Foundation
import UIKit

final class CatCellController {
    private let viewModel: CatImageViewModel<UIImage>

    init(viewModel: CatImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }

    func view() -> UITableViewCell {
        let cell = binded(UITableViewCell(style: .default, reuseIdentifier: "Cell"))
        viewModel.loadImageData()
        return cell
    }

    func preload() {
        viewModel.loadImageData()
    }

    func cancelLoad() {
        viewModel.cancelImageDataLoad()
    }

    func select() {
        viewModel.select()
    }

    private func binded(_ cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.text = viewModel.name
        cell.accessoryType = .disclosureIndicator

        viewModel.onImageLoad = { [weak cell] image in
            cell?.imageView?.image = image
        }

        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            if isLoading {
                cell?.imageView?.startShimmering()
            } else {
                cell?.imageView?.stopShimmering()
            }
        }

        return cell

    }
}
