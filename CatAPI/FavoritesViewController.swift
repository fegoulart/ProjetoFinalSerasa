//
//  FavoritesViewController.swift
//  CatAPI
//
//

import UIKit
import CatLoader
#if DEBUG
import SwiftUI
#endif

class FavoritesViewController: UIViewController {

    var favorites: [Cat] = []
    var localRepository: CoreDataRepository?
    lazy var favoritesTableView: UITableView = {
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

    // TODO: Move it to CatUIComposer
    convenience init(localRepository: CoreDataRepository) {
        self.init()
        self.localRepository = localRepository
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.favoritesTableView)
        self.navigationController?.tabBarController?.tabBar.barTintColor = .systemGray
        self.navigationController?.tabBarController?.tabBar.backgroundColor = .systemGray
        self.navigationController?.tabBarController?.tabBar.tintColor = .white
        self.navigationController?.tabBarController?.tabBar.unselectedItemTintColor = .darkGray
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try? localRepository?.getFavoritesFromLocal { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let cats):
                self?.favorites = cats
                self?.favoritesTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        self.tabBarController?.tabBar.backgroundColor = .systemGray
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.favorites[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        let cat = self.favorites[indexPath.row]
        if let imageURL = cat.imageUrl {
            if let url = URL(string: imageURL) {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.global(qos: .background).async {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            let cell = self.favoritesTableView.cellForRow(at: indexPath)
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

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCat = favorites[indexPath.row]
        let localRepository = CoreDataRepository()
        let detailViewController = DetailViewController(
            cat: selectedCat,
            catImage: UIImage(),
            localRepository: localRepository
        )
        show(detailViewController, sender: nil)
    }
}

#if DEBUG
struct FavoritesViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SuggestionViewController()
        }
    }
}
#endif
