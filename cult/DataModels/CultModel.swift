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
    
    var uid: String!
    var cultName: String!
    
    override init() {
        
    }
    
    init(jsonData: JSON){
        
        uid = jsonData["uid"].stringValue
        cultName = jsonData["cult_name"].stringValue
        
    }
    
}















