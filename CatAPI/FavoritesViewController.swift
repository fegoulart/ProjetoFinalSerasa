//
//  FavoritesViewController.swift
//  CatAPI
//
//  Created by Fernando Goulart on 30/10/21.
//

import UIKit
#if DEBUG
import SwiftUI
#endif

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

#if DEBUG
struct FavoritesViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SuggestionViewController()
        }
    }
}
#endif
