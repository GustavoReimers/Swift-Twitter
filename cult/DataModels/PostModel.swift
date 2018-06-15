//
//  PostModel.swift
//  Cult
//
//  Created by iOS Developer on 6/12/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import SwiftyJSON

class PostModel: NSObject {
    
    var nType:Int!
    var img_url:String!
    var img_avatar:String!
    var tx_caption:String!
    var tx_name:String!
    var nTimeMili:Double!
    var username:String!
    
    init(jsonData: NSDictionary){
        nType = jsonData["type"] as! Int
        img_url = jsonData["image"] as! String
        img_avatar = jsonData["user_avatar"] as! String
        tx_caption = jsonData["caption"] as! String
        tx_name = jsonData["display_name"] as! String
        nTimeMili = jsonData["time"] as! Double
        username = jsonData["user_name"] as! String
    }
    
}
