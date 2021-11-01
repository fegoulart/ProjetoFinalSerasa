//
//  BestCatsViewController.swift
//  CatAPI
//
//  Created by Fernando Goulart on 01/11/21.
//

import UIKit
#if DEBUG
import SwiftUI
#endif

class BestCatsViewController: UIViewController {

    var suggestions: [Cats] = []

    convenience init(suggestions: [Cats] ) {
        self.init()
        self.suggestions = suggestions
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

#if DEBUG
struct BestCatsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            BestCatsViewController()
        }
    }
}
#endif
