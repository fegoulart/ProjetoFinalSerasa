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

    @IBOutlet weak var kidsFriendlyButton: UIButton!
    @IBOutlet weak var iAmReadyButton: UIButton!

    var cats: [Cats] = []
    var suggestionsCats: [Cats] = []
    var api: API?

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        botaoInicio.layer.cornerRadius = 20
        getBreeds {  [weak self] result in
            guard self != nil else { return }
            self?.indicator.stopAnimating()
        }

    }
    convenience init(api: API) {
        self.init()
        self.api = api
    }
    private func getBreeds(completion: @escaping ((Result < [Cats], APIError>)  -> Void)) {
        guard let mApi = api else {return}
        mApi.getCats(urlString: mApi.setCatBreedsURL(), method: .GET){
            [weak self] result in
            guard self != nil else { return }
            switch result{
            case .success(let cats):
                self?.cats = cats
            case .failure(let error):
                print (error)
            }
        }
    }
}

extension HomeViewController {
//    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
//            // ACTION do I am Ready Button
//        self.suggestionsCats = self.cats
//        if kidsFriendlyButton.isSelected {
//           // self.suggestionsCats.filter { $0.kidsFriendly > 3 } // So fa
//        }
//    }
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
