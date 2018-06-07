//
//  UserModel.swift
//  Cult
//
//  Created by Han on 5/25/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import SwiftyJSON

class CultModel: NSObject {
    
    var id: Int!
    var cultName: String!
    
    override init() {
        
    }
    
    init(jsonData: JSON){
        
        id = jsonData["id"].intValue
        cultName = jsonData["cult_name"].stringValue
        
    }
    
}















