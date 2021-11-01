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

class HomeViewController: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var botaoInicio: UIButton!

    var cats: [Cats] = []
    var suggestionsCats: [Cats] = []
    var api: API?

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        botaoInicio.layer.cornerRadius = 20
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

    convenience init(api: API) {
        self.init()
        self.api = api
    }

    private func getBreeds(completion: @escaping ((Result < [Cats], APIError>) -> Void)) {
        guard let mApi = api else {return}
        mApi.getCats(urlString: mApi.setCatBreedsURL(), method: .GET) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let cats):
                completion(Result.success(cats))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }

    @IBAction func prontissimoButtonAction(_ sender: UIButton) {
        let suggestionViewController = SuggestionViewController(allBreeds: self.cats)
        self.show(suggestionViewController, sender: nil)
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
