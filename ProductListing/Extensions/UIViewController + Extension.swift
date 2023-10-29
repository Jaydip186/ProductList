//
//  UIViewController + Extension.swift
//  ProductListing
//
//  Created by Moksh Marakana on 29/10/23.
//

import Foundation
import UIKit
import MBProgressHUD


extension UIViewController {
    
    func show_alert(msg:String)
    {
        DispatchQueue.main.async
        {
            let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func showHud(_ message: String) {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = message
            hud.isUserInteractionEnabled = false
        }

        func hideHUD() {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
}
