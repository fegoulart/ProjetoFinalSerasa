//
//  SuggestionViewController.swift
//  CatAPI
//
//  Created by Thayanne Viana on 30/10/21.
//

import UIKit

class SuggestionViewController: UIViewController {
    var suggestions: [Cats]?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

    }

    convenience init(allBreeds: [Cats] ) {
        self.init()
        self.suggestions = allBreeds
    }




}
