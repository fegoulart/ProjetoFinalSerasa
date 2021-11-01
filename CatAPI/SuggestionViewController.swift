//
//  SuggestionViewController.swift
//  CatAPI
//
//  Created by Thayanne Viana on 30/10/21.
//

import UIKit
#if DEBUG
import SwiftUI
#endif

class SuggestionViewController: UIViewController {
    var suggestions: [Cats]?
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    convenience init(allBreeds: [Cats] ) {
        self.init()
        self.suggestions = allBreeds
    }
}

#if DEBUG
struct SuggestionViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SuggestionViewController()
        }
    }
}
#endif
