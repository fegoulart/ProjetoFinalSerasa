//
//  ViewController.swift
//  CatAPI
//
//  Created by Thayanne Viana on 21/10/21.
//

import UIKit
#if DEBUG
import SwiftUI
#endif

class ViewController: UIViewController {

    let api = API()
    var cats: [Cats] = []
    var error = ""

    lazy var  newTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.dataSource = self
        // tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        return tableView

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Gatos"
        self.view.addSubview(self.newTableView)

        api.getCats(urlString: api.setCatBreedsURL(), method: .GET) { gatos in

            self.cats = gatos

            DispatchQueue.main.async {
                self.newTableView.reloadData()
            }
            print("GATOS: \(self.cats.count)")
        } errorReturned: { error in
            self.error = error
            print("Erro: \(error.description)")
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // cell.textLabel?.text = self.cats[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        var content = cell.defaultContentConfiguration()
        let cat = self.cats[indexPath.row]
        if let imageURL = cat.image?.url {
            if let url = URL(string: imageURL) {
                if let data = try? Data(contentsOf: url) {
                    content.image = UIImage(data: data)
                    content.imageProperties.reservedLayoutSize = CGSize(width: 50.0, height: 50.0)
                    content.imageProperties.maximumSize = CGSize(width: 50.0, height: 50.0)
                }
            }
        }
        if let texto = cat.name {
            content.text = texto
        }

        cell.contentConfiguration = content

        return cell
    }
}

// extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//           let dvc = DetailViewController()
//           dvc.cat = self.cats[indexPath.row]
//           dvc.title = dvc.cat.name
//           self.show(dvc, sender: nil)
//       }
// }

#if DEBUG
struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            ViewController()
        }
    }
}
#endif

class Fernando {

}
