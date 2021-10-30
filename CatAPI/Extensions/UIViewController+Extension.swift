//
//  UIViewController+Extension.swift
//  CatAPI
//
//  Created by Fernando Goulart on 30/10/21.
//

import UIKit
#if DEBUG
import SwiftUI
#endif

extension UIViewController {

#if DEBUG
    @available(iOS 13, *)
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }

    @available(iOS 13, *)
    func showPreview() -> some View {
        Preview(viewController: self)
    }
#endif
}
