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

// MVVM ViewControllers should not know Core components, for instance "CatLoader" Module
// They should act just as binders between Views and ViewModels
public final class HomeViewController: UIViewController, CatLoadingView, CatView {

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
    private var presenter: HomePresenter?

    convenience init(presenter: HomePresenter) {
        self.init()
        self.presenter = presenter
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        botaoInicio.layer.cornerRadius = 20
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0

        presenter?.loadBreeds()
    }
    func display(_ viewModel: CatLoadingViewModel) {
        if viewModel.isLoading {
            indicator?.startAnimating()
        } else {
            indicator?.stopAnimating()
        }
    }

    func canDisplayNextView(suggestionViewController: SuggestionViewController) {
        self.suggestionViewController = suggestionViewController
    }

//    private func bind() {
//        guard let mViewModel = viewModel else { return }
//        mViewModel.onLoadingStateChange = { [weak indicator] isLoading in
//
//        }
//    }

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
