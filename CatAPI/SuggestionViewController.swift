//
//  SuggestionViewController.swift
//  CatAPI
//
//  Created by Thayanne Viana on 30/10/21.
//

import UIKit

class SuggestionViewController: UIViewController {
    var suggestions:[Cats]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    convenience init(allBreeds: [Cats] ) {
        self.init()
        self.suggestions = allBreeds
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
