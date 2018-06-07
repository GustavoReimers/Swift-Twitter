//
//  MenuVC.swift
//  Cult
//
//  Created by Han on 6/1/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func onLogOutButton(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: ISLOGGEDIN)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StartNav")
        UIApplication.shared.keyWindow?.rootViewController = controller
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
