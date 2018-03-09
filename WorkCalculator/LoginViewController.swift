//
//  ViewController.swift
//  mHealth
//
//  Created by Loaner on 2/28/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController{
    
    let nextSegue = "postLoginSegue"
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginDidTouch(_ sender: Any) {
        loginFunction()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text = "travis@dev.com"
        passwordField.text = "myPassword"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func loginFunction(){
        Auth.auth().signIn(withEmail: emailField.text!,
                               password: passwordField.text!, completion: { user, error in
                                
            if error != nil { //unsucessful
                let alert = UIAlertController(title: "Login Error",
                                              message: "Register for an account or try again",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay",
                                             style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
               // self.dismiss(animated: true, completion: nil)//---->>>>?? why is this here
                print("signed in")
                self.performSegue(withIdentifier: self.nextSegue, sender: nil)
            }
        })

    }
}

