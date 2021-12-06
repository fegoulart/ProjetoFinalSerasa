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

public class SuggestionViewController: UIViewController {
    var viewModel: SuggestionViewModel?
    var bestCatsViewController: BestCatsViewController?

    // MARK: Outlets

    @IBOutlet weak var indoorUIButton: UIButton!
    @IBOutlet weak var vocalizingUIButton: UIButton!
    @IBOutlet weak var lapUIButton: UIButton!
    @IBOutlet weak var sociableUIButton: UIButton!
    @IBOutlet weak var sheddingUIButton: UIButton!
    @IBOutlet weak var rareUIButton: UIButton!
    @IBOutlet weak var goUIButton: UIButton!

    // MARK: ViewController Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions
    @IBAction func selectUIButton(_ sender: UIButton) {
        print(sender.state)
    }

    @IBAction func goUIButton(_ sender: UIButton) {
        guard let mViewModel = viewModel else { return }
        let userWish = Suggestion(
            indoor: indoorUIButton.isSelected,
            vocalize: vocalizingUIButton.isSelected,
            lap: lapUIButton.isSelected,
            sociable: sociableUIButton.isSelected,
            shedding: sheddingUIButton.isSelected,
            rare: rareUIButton.isSelected
        )

        mViewModel.setUserWish(userWish)
        if let mViewController = self.bestCatsViewController {
            self.show(mViewController, sender: nil)
        } else {
            let alert = UIAlertController(
                title: "Ops, não encotramos felinos com esse perfil!",
                message: "Escolha mais características!",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: { action in
                    switch action.style {
                    case .default:
                        print("default")
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    @unknown default:
                        fatalError()
                    }}))
            self.present(alert, animated: true, completion: nil)
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
