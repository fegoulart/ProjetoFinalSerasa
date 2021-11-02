//
//  BestCatsViewController.swift
//  CatAPI
//
//  Created by Fernando Goulart on 01/11/21.
//

import UIKit
#if DEBUG
import SwiftUI
#endif

class BestCatsViewController: UIViewController {

    var suggestions: [Cats] = []
    lazy var suggestionsTableView: UITableView = {
        let mFrame = CGRect(
                           x: 0.0,
                            y: 0.0,
                            width: self.view.bounds.width,
                            height: self.view.bounds.height
        )
        var tableView = UITableView(frame: mFrame)
        tableView.rowHeight = 70
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    convenience init(suggestions: [Cats] ) {
        self.init()
        self.suggestions = suggestions
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.suggestionsTableView)
        self.navigationController?.tabBarController?.tabBar.barTintColor = .systemGray
        self.navigationController?.tabBarController?.tabBar.backgroundColor = .systemGray
        self.navigationController?.tabBarController?.tabBar.tintColor = .white
        self.navigationController?.tabBarController?.tabBar.unselectedItemTintColor = .darkGray
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.suggestionsTableView.reloadData()
        self.tabBarController?.tabBar.backgroundColor = .systemGray
    }
}

extension BestCatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.suggestions[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        let cat = self.suggestions[indexPath.row]
        if let imageURL = cat.image?.url {
            if let url = URL(string: imageURL) {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.global(qos: .background).async {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            let cell = self.suggestionsTableView.cellForRow(at: indexPath)
                            var content = cell?.defaultContentConfiguration()
                            content?.imageProperties.reservedLayoutSize = CGSize(width: 50.0, height: 50.0)
                            content?.imageProperties.maximumSize = CGSize(width: 50.0, height: 50.0)
                            content?.image = image
                            if let texto = cat.name {
                                content?.text = texto
                            }
                            cell?.contentConfiguration = content
                        }
                    }
                }
            }
        } else {
            var content = cell.defaultContentConfiguration()
            content.imageProperties.reservedLayoutSize = CGSize(width: 50.0, height: 50.0)
            content.imageProperties.maximumSize = CGSize(width: 50.0, height: 50.0)
            content.image = UIImage(named: "cat")
            if let texto = cat.name {
                content.text = texto
            }
            cell.contentConfiguration = content
        }
        return cell
    }
}

extension BestCatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCat = suggestions[indexPath.row]
        let selectedCell = self.suggestionsTableView.cellForRow(at: indexPath)
        let selectedCatImage = selectedCell?.defaultContentConfiguration().image
        let detailViewController = DetailViewController(cat: selectedCat, catImage: selectedCatImage ?? UIImage())
        show(detailViewController, sender: nil)
    }
}

#if DEBUG
struct BestCatsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            BestCatsViewController()
        }
    }
}
#endif
