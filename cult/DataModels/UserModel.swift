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
    
    var id: Int!
    var userName: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var birthday: String!
    var profileImageUrl: String!
    var role: Int!
    
    override init() {
        
    }
    
    init(jsonData: JSON){
        
        id = jsonData["id"].intValue
        userName = jsonData["username"].stringValue
        firstName = jsonData["first_name"].stringValue
        lastName = jsonData["last_name"].stringValue
        email = jsonData["email"].stringValue
        birthday = jsonData["birth"].stringValue
        role = jsonData["role"].intValue
        profileImageUrl = jsonData["avatar_url"].stringValue
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
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
        
        id = aDecoder.decodeObject(forKey: "id") as! Int
        userName = aDecoder.decodeObject(forKey: "userName") as! String
        firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        birthday = aDecoder.decodeObject(forKey: "birthday") as! String
        profileImageUrl = aDecoder.decodeObject(forKey: "profileImageUrl") as! String
        role = aDecoder.decodeObject(forKey: "role") as! Int
        
    }
}
