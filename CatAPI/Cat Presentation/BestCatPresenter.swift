//
//  BestCatPresenter.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 06/12/21.
//

import Foundation
import CatLoader

struct BestCatsViewModel {
    let cats: [Cat]
}

protocol BestCatView {
    func display(_ viewModel: BestCatsViewModel)
}

final class BestCatPresenter {

    var bestCatView: BestCatView

    // Presenter is not responsible anymore for "asking for data"
    // var catLoader: RemoteCatLoader
    //
    //    init(catLoader: RemoteCatLoader = LocalCatLoader()) {
    //        self.catLoader = catLoader
    //    }

    init(bestCatView: BestCatView) {
        self.bestCatView = bestCatView
    }

    // using delegate
    func didFinishLoadingCat(with cat: [Cat]) {
        let viewModel = BestCatsViewModel(cats: cat)
        self.bestCatView.display(viewModel)
    }

    func didFinishLoadingCat(with error: Error) {

    }
}
