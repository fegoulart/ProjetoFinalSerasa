//
//  ViewControllerPreview.swift
//  CatAPI
//
//  Created by Fernando Goulart on 30/10/21.
//

#if DEBUG
import SwiftUI

struct ViewControllerPreview: UIViewControllerRepresentable {

    typealias UIViewControllerType = UIViewController
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    func makeUIViewController(context: Context) -> UIViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }
}
#endif
