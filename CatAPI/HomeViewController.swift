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

class HomeViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var botaoInicio: UIButton!

    var cats: [Cat] = []
    var suggestionsCats: [Cat] = []
    var catLoader: RemoteCatLoader?

    override func viewDidLoad() {
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
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    convenience init(catLoader: RemoteCatLoader) {
        self.init()
        self.catLoader = catLoader
    }

    private func getBreeds(completion: @escaping ((Result < [Cat], CatLoader.Error>) -> Void)) {
        guard let loader = catLoader else { completion(Result.failure(.connectivity))
            return
        }
        loader.load { [weak self] result in
            guard self != nil else { return }
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
        if self.indicator.isAnimating {
            let alert = UIAlertController(title: "Ops ", message: "Verifique sua conexão!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
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
        } else {
            let suggestionViewController = SuggestionViewController(allBreeds: self.cats)
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
