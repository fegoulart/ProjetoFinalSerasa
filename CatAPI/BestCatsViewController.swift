//
//  BestCatsViewController.swift
//  CatAPI
//
//

import UIKit
#if DEBUG
import SwiftUI
#endif

public class BestCatsViewController: UIViewController {

    var suggestions = [CatCellController]()
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
    var detailViewController: DetailViewController?

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
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return suggestions[indexPath.row].view()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
}

extension BestCatsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        suggestions[indexPath.row].select()
        if let detailVC = self.detailViewController {
            show(detailVC, sender: nil)
        }
    }

    public func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }

    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath)?.cancelLoad()
    }

    private func cellController(forRowAt indexPath: IndexPath) -> CatCellController? {
        return suggestions[indexPath.row]
    }
}

extension BestCatsViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            if let cellController = cellController(forRowAt: indexPath) {
                cellController.preload()
            }
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
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
