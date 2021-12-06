//
//  BestCatPresenter.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 06/12/21.
//

import Foundation
import CatLoader

protocol BestCatView {
    func display()
}

final class BestCatPresenter {

    var bestCatView: BestCatView?

    func loadCats() {
        self.bestCatView?.display()
    }
}
