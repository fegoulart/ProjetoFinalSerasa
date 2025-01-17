//
//  BestCatsViewController.swift
//  CatAPI
//
//

import UIKit
import CatLoader
#if DEBUG
import SwiftUI
#endif

public class BestCatsViewController: UIViewController {

    var suggestions: [Cat] = []
    lazy public var suggestionsTableView: UITableView = {
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

    private var imageLoader: CatImageDataLoader?
    // Technique to move state management to client
    private var tasks = [IndexPath: CatImageDataLoaderTask]()

    public convenience init(suggestions: [Cat], imageLoader: CatImageDataLoader) {
        self.init()
        self.suggestions = suggestions
        self.imageLoader = imageLoader
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.suggestionsTableView)
        suggestionsTableView.prefetchDataSource = self
        self.navigationController?.tabBarController?.tabBar.barTintColor = .systemGray
        self.navigationController?.tabBarController?.tabBar.backgroundColor = .systemGray
        self.navigationController?.tabBarController?.tabBar.tintColor = .white
        self.navigationController?.tabBarController?.tabBar.unselectedItemTintColor = .darkGray
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.suggestionsTableView.reloadData()
        self.tabBarController?.tabBar.backgroundColor = .systemGray
    }
}

extension BestCatsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.suggestions[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        let cat = self.suggestions[indexPath.row]
        cell.imageView?.startShimmering()
        if let imageURL = cat.imageUrl {
            if let url = URL(string: imageURL) {
                let loadImage = { [weak self, weak cell] in
                    guard let self = self else { return }
                    self.tasks[indexPath] = self.imageLoader?.loadImageData(from: url) { [weak cell] result in
                        let data = try? result.get()
                        let image = data.map(UIImage.init) ?? nil
                        cell?.imageView?.image = image
                        cell?.imageView?.stopShimmering()
                    }
                }
                loadImage()
            }
        } else {
            // TODO: Send this ELSE logic to imageLoader
            var content = cell.defaultContentConfiguration()
            content.imageProperties.reservedLayoutSize = CGSize(width: 50.0, height: 50.0)
            content.imageProperties.maximumSize = CGSize(width: 50.0, height: 50.0)
            content.image = UIImage(named: "cat")
            if let texto = cat.name {
                content.text = texto
            }
            cell.contentConfiguration = content
            cell.stopShimmering()
        }
        return cell
    }
}

extension BestCatsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCat = suggestions[indexPath.row]
        let localRepository = CoreDataRepository()
        let detailViewController = DetailViewController(
            cat: selectedCat,
            catImage: UIImage(),
            localRepository: localRepository
        )
        show(detailViewController, sender: nil)
    }

    public func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        cancelTask(forRowAt: indexPath)
    }

    private func cancelTask(forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
}

extension BestCatsViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let cellModel = suggestions[indexPath.row]
            if let url = cellModel.imageUrl, let imageURL = URL(string: url) {
                tasks[indexPath] = imageLoader?.loadImageData(from: imageURL) { _ in }
            }
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cancelTask(forRowAt: indexPath)
        }
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
