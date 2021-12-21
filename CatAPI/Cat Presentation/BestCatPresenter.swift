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

    var bestCatView: BestCatView?

    func loadCats() {
        let cats: BestCatsViewModel = BestCatsViewModel(cats: [])
        self.bestCatView?.display(cats)
    }
}
