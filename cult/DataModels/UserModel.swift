//
//  UserModel.swift
//  Cult
//
//  Created by Han on 5/25/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserModel: NSObject, NSCoding {
    
    var uid: String!
    var userName: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var birthday: String!
    var profileImageUrl: String!
    var role: Int!
    var gender: String!
    override init() {
        
    }
    
    init(jsonData: NSDictionary){
        
        uid = jsonData["uid"] as! String?
        userName = jsonData["username"] as! String
        firstName = jsonData["first_name"] as! String
        lastName = jsonData["last_name"] as! String
        email = jsonData["email"] as! String
        birthday = jsonData["birth"] as! String
        role = jsonData["role"] as! Int
        profileImageUrl = jsonData["avatar"] as! String
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(profileImageUrl, forKey: "profileImageUrl")
        aCoder.encode(role, forKey: "role")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        
        uid = aDecoder.decodeObject(forKey: "uid") as! String
        userName = aDecoder.decodeObject(forKey: "userName") as! String
        firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        birthday = aDecoder.decodeObject(forKey: "birthday") as! String
        profileImageUrl = aDecoder.decodeObject(forKey: "profileImageUrl") as! String
        role = aDecoder.decodeObject(forKey: "role") as! Int
        
    }
}
