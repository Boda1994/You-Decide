//
//  ViewController.swift
//  virtual tourist
//
//  Created by Abdualrahman on 6/16/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
