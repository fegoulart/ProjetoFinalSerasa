//
//  HomeViewController.swift
//  CatAPI
//
//  Created by Thayanne Viana on 29/10/21.
//

import UIKit
#if DEBUG
import SwiftUI
#endif

// In MVVM ViewController should not know Core components as "CatLoader"
public final class HomeViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    @IBOutlet public weak var indicator: UIActivityIndicatorView!
    @IBOutlet public weak var botaoInicio: UIButton!
    public lazy var alert: UIAlertController = {
        let mAlert = UIAlertController(title: "Ops ", message: "Verifique sua conexão!", preferredStyle: .alert)
        mAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
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
        return mAlert
    }()
    var noCatsAlertAction: (() -> Void)?

    var suggestionViewController: SuggestionViewController?
    var viewModel: CatViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        botaoInicio.layer.cornerRadius = 20
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0

        bind()
        viewModel?.loadBreeds()
    }

    private func bind() {
        guard let mViewModel = viewModel else { return }
        mViewModel.onChange = { [weak self] viewModel in
            if viewModel.isLoading {
                self?.indicator.startAnimating()
            } else {
                self?.indicator.stopAnimating()
            }
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func prontissimoButtonAction(_ sender: UIButton) {
        guard let sViewController = suggestionViewController else {
            guard let mAction = self.noCatsAlertAction else {
                return
            }
            mAction()
            return
        }
        self.show(sViewController, sender: nil)
    }
}

#if DEBUG
struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            HomeViewController()
        }
    }
}
#endif
