//
//  WorkUser.swift
//  WorkCalculator
//
//  Created by Loaner on 5/10/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import Firebase

struct WorkUser{
    
    let uid: String
    let email: String
    let name: String
    
    let ref: DatabaseReference?
    
    init(uid: String, email: String, name: String = " "){
        self.uid = uid
        self.email = email
        self.name = name
        self.ref = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "uid":uid,
            "email":email,
            "name":name,
            ]
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid = snapshotValue["uid"] as! String
        email = snapshotValue["email"] as! String
        name = snapshotValue["name"] as! String
        ref = snapshot.ref;
    }
    
}
