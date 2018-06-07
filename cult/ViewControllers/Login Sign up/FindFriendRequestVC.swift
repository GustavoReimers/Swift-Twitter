//
//  FindFriendRequestVC.swift
//  Cult
//
//  Created by Han on 5/22/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import SwiftyContacts


class FindFriendRequestVC: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        AppManager.shared.setBorderToUIView(view: continueButton, width: 1, color: UIColor.init(rgb: 0x21283B))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonTap(_:)))
        backButton.addGestureRecognizer(tap)
        
    }

    @IBAction func onContinueButton(_ sender: Any) {
        
        authorizationStatus { (status) in
            switch status {
            case .authorized:
                
                self.performSegue(withIdentifier: "AddFriendSegue", sender: nil)
                
                break
            case .denied:
                print("denied")
                self.showPermissionAlert()
                break
            case .notDetermined:
                
                requestAccess { (responce) in
                    if responce{
                        
                        self.performSegue(withIdentifier: "AddFriendSegue", sender: nil)
                        
                        print("Contacts Acess Granted")
                    } else {
                        print("Contacts Acess Denied")
                    }
                }
                
                break
            default:
                break
            }
        }
        
    }
    
    
    func showPermissionAlert() {
        
        let alert = UIAlertController(title: "", message: "Allow App to access contacts"
            , preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingAction = UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            let url = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.openURL(url!)
        })
        
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        alert.preferredAction = settingAction
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func onSkipButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Cult is more fun when you add friends and see their posts. Are you sure you want to skip this step?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Skip", style: .cancel, handler: { action in
            AppManager.shared.goToMainTabBar()
        }))
        
        alert.addAction(UIAlertAction(title: "Add Friends", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func backButtonTap(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
