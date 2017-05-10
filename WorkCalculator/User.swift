//
//  User.swift
//  mHealth
//
//  Created by Loaner on 3/2/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    let userRef: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
        userRef = Util.replacePeriod(s: authData.email!)
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
        self.userRef = Util.replacePeriod(s: email)
    }
    
}
