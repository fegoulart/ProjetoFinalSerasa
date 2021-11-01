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

    // MARK: Outlets

    @IBOutlet weak var indoorUIButton: UIButton!
    @IBOutlet weak var vocalizingUIButton: UIButton!
    @IBOutlet weak var lapUIButton: UIButton!
    @IBOutlet weak var sociableUIButton: UIButton!
    @IBOutlet weak var sheddingUIButton: UIButton!
    @IBOutlet weak var rareUIButton: UIButton!
    @IBOutlet weak var goUIButton: UIButton!

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    convenience init(allBreeds: [Cats] ) {
        self.init()
        self.suggestions = allBreeds
    }

    // MARK: Actions

    @IBAction func selectUIButton(_ sender: UIButton) {
        print(sender.state)
    }

    @IBAction func goUIButton(_ sender: UIButton) {
        let userWish = Suggestion(
            indoor: indoorUIButton.isSelected,
            vocalize: vocalizingUIButton.isSelected,
            lap: lapUIButton.isSelected,
            sociable: sociableUIButton.isSelected,
            shedding: sheddingUIButton.isSelected,
            rare: rareUIButton.isSelected
        )
        let suggestedBreeds = FilterBreed.getSuggestions(breeds: suggestions ?? [], wish: userWish)
        if suggestedBreeds.count > 0 {
            let bestCatsViewController = BestCatsViewController(suggestions: suggestedBreeds)
            self.show(bestCatsViewController, sender: nil)
        } else {
            print("Nenhum gato encontrado")
        }
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
