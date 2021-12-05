//
//  HomeViewController.swift
//  CatAPI
//
//  Created by Thayanne Viana on 29/10/21.
//

import UIKit
import CatLoader
#if DEBUG
import SwiftUI
#endif

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

    var cats: [Cat] = []
    var suggestionsCats: [Cat] = []
    var catLoader: RemoteCatLoader?

    public override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        botaoInicio.layer.cornerRadius = 20
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        getBreeds {  [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let cats):
                self?.cats = cats
            case .failure(let error):
                print(error)
            }
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func getBreeds(completion: @escaping ((Result < [Cat], CatLoader.Error>) -> Void)) {
        guard let loader = catLoader else { completion(Result.failure(.connectivity))
            return
        }
        loader.load { [weak self] result in
            guard self != nil else { return }
            self?.indicator.stopAnimating()
            // if we care just for success we can use an if let cats = try? result.get() {
            switch result {
            case .success(let cats):
                print("\(cats.count) GATOS CARREGADOS COM SUCESSO")
                completion(.success(cats))
            case .failure(let error):
                print(error)
                completion(.failure(CatLoader.Error.invalidData))
            }
        }
    }

    @IBAction func prontissimoButtonAction(_ sender: UIButton) {
        if self.cats.count == 0 {
            guard let mAction = self.noCatsAlertAction else {
                return
            }
            mAction()
        } else {
            let suggestionViewController = CatUIComposer.suggestionsComposedWith(allBreeds: self.cats)
            self.show(suggestionViewController, sender: nil)
        }
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
