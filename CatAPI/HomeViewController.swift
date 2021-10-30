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
    @IBOutlet weak var botaoInicio: UIButton!
    @IBOutlet weak var fundo: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fundo.layer.cornerRadius = 20
        botaoInicio.layer.cornerRadius = 20
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
