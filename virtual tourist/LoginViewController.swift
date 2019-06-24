//
//  LoginViewController.swift
//  virtualtourist
//
//  Created by Abdualrahman on 6/24/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else {
            print("Invaild Registertion URL!")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailField.text?.trimmingCharacters(in: .whitespaces),
            let password = passwordField.text?.trimmingCharacters(in: .whitespaces),
            !email.isEmpty, !password.isEmpty
            else {
                alert(title: "Waring", message: "Email and Password should not be empty!")
                updateUI(processing: false)
                return
        }
        UdacityAPI.postSession(with: email, password: password) {(result, error)in
            if let error =  error {
                self.alert(title: "Error", message: error.localizedDescription)
                self.updateUI(processing: false)
                return
            }
            if let error = result?["error"] as? String {
                self.alert(title: "Error", message: error)
                self.updateUI(processing: false)
                return
            }
            if let session = result?["session"] as? [String:Any], let sessionId = session["id"] as? String {
                print(sessionId)
                UdacityAPI.deleteSession { (error) in
                    if let error = error {
                        self.alert(title: "Error", message: error.localizedDescription)
                        self.updateUI(processing: false)
                        return
                    }
                    self.updateUI(processing: false)
                    DispatchQueue.main.async {
                        self.emailField.text = ""
                        self.passwordField.text = ""
                        self.performSegue(withIdentifier: "MapViewController", sender: self)
                    }
                }
            }
            self.updateUI(processing: false)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func updateUI(processing: Bool) {
        DispatchQueue.main.async {
            self.emailField.isUserInteractionEnabled = !processing
            self.passwordField.isUserInteractionEnabled = !processing
            self.loginButton.isEnabled = !processing
        }
    }
    
}
