//
//  UIView + Extension.swift
//  ProductListing
//
//  Created by Moksh Marakana on 29/10/23.
//

import Foundation
import UIKit


@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue
              layer.masksToBounds = (newValue > 0)
        }
    }
}
