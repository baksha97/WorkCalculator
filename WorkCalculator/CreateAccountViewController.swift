//
//  CreateAccountViewController.swift
//  mHealth
//
//  Created by Loaner on 3/3/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    //MARK:Firebase
    var user = (Auth.auth().currentUser)
    var referencedUser: UserData? = nil
    let ref = Database.database().reference(withPath: "users")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
   
    
    @IBAction func createAccountDidTouch(_ sender: Any) {
        createAccount()
    }
    
    private func createAccount(){
        if((passwordField.text! == confirmPasswordField.text!)){
            Auth.auth().createUser(withEmail: emailField.text!,
                                   password: passwordField.text!) { user, error in
                                    if error != nil { //unsucessful
                                        let alert = UIAlertController(title: "Create account error",
                                                                      message: "Please enter a valid email address. \n Please enter a password more than 6 characters in length. \n Now, please login!",
                                                                      preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "Okay",
                                                                     style: .default)
                                        alert.addAction(okAction)
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    else{
                                        self.addUserFirebase()
                                        self.dismiss(animated: true, completion: nil)
                                        }
        }
        }else{
            let alert = UIAlertController(title: "Creation error",
                                          message: "Please confirm the passwords are the same",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            passwordField.text = ""
            confirmPasswordField.text = ""
        }
    }

    
    func addUserFirebase(){
        self.user = Auth.auth().currentUser
        /// adding user to firebase database:
        let newUser: WorkUser = WorkUser(   uid: (self.user!.uid),
                                               email: (self.user?.email)!,
                                               name: nameField.text!)
        // 1
        referencedUser = UserData(authData: user!)
        let currentUserRef = self.ref.child(referencedUser!.userRef)

        // 2
        let userDataRef = currentUserRef.child("User-Data/account/user")
        userDataRef.setValue(newUser.toAnyObject())

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func BackBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
