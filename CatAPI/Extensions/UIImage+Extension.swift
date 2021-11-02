//
//  UIImage+Extension.swift
//  CatAPI
//
//  Created by Fernando Goulart on 02/11/21.
//

import Foundation
import UIKit

extension UIImage {
  func jpegData(withCompressionQuality quality: CGFloat) -> Data? {
    return autoreleasepool(invoking: {() -> Data? in
        return self.jpegData(compressionQuality: quality)
    })
  }
}
