//
//  AddFriendVC.swift
//  Cult
//
//  Created by Han on 5/22/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import SwiftyContacts
import MBProgressHUD
import SDWebImage

class AddFriendVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AddFriendCellDelegate {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var userTable: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var emailArray: [String] = []
    var userArray: [UserModel] = []
    var resultArry: [UserModel] = []
    
    var requestedUserArray: [UserModel] = []
    var requestedCultArray: [CultModel] = []
    
    var requestedUser: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppManager.shared.setBorderToUIView(view: continueButton, width: 1, color: UIColor.init(rgb: 0x21283B))
        
        setPlaceholder(textField: searchTextField, placeholderString: "Search")

        self.userTable.delegate = self
        self.userTable.dataSource = self
        
        searchTextField.delegate = self
        
        getContacts()
    }
    
    //fetch contact list
    
    func getContacts(){
        
        fetchContacts(completionHandler: { (result) in
            switch result{
            case .Success(response: let contacts):
                
                for contact in contacts{
                    
                    for email in contact.emailAddresses{
                        
                        print(email.value)
                        self.emailArray.append(email.value as String)
                        
                    }
                    
                }
                
                self.findFriends()
                
                break
            case .Error(error: let error):
                print(error)
                break
            }
        })
        
    }
    
    //Find friends
    
    func findFriends(){
 
        AppManager.shared.showLoadingIndicator(view: self.view)
        
        let params = ["fri_emails": self.emailArray] as [String: Any]
        
        print(params)
        
        APIManager.shared.findFriends(params: params, token: UserDefaults.standard.string(forKey: TOKEN)!) { (error, response) in
            
            if error == nil{
                
                print(response)
                
                let users = response["friends"].array
                
                for user in users!{
                    
                    let data = UserModel.init(jsonData: user)
                    self.resultArry.append(data)
                    self.userArray.append(data)
                    
                }
    
                self.userTable.reloadData()
                
            }else{
                
                print(error!.localizedDescription)
                
            }
        
            AppManager.shared.hideLoadingIndicator()
        }
        
    }
    
    //Search Feature
    
    @IBAction func searchTextDidChanged(_ sender: Any) {
        
        let searchTextField = sender as! UITextField
        
        self.userArray.removeAll()
        
        if searchTextField.text == ""{
            for user in resultArry{
                userArray.append(user)
            }
            self.userTable.reloadData()
            return
        }
        
        for user in resultArry{
            
            if (user.firstName + " " + user.lastName).lowercased().contains(searchTextField.text!.lowercased()){
                
                self.userArray.append(user)
                
            }
        
        }
        
        self.userTable.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AddFriendCell = tableView.dequeueReusableCell(withIdentifier: "AddFriendCell") as! AddFriendCell
        
        let user = userArray[indexPath.row]
        
        cell.nameLabel.text = user.firstName + " " + user.lastName
        cell.idLabel.text = "@" + user.userName

        AppManager.shared.makeCircleToUIView(view: cell.photoImageView)
        
        cell.photoImageView.sd_setImage(with: URL.init(string: user.profileImageUrl), placeholderImage: UIImage.init(named: "person-placeholder"), options: .refreshCached) { (image, error, cacheType, url) in
            
            AppManager.shared.makeCircleToUIView(view: cell.photoImageView)
            
        }
 
        AppManager.shared.setBorderToUIView(view: cell.addButton, width: 1, color: UIColor.init(rgb: 0x28375A))
        
        if requestedUserArray.contains(user){
            cell.addButton.setTitle("CANCEL", for: .normal)
            cell.cultNameLabel.isHidden = false
            
            let index = self.requestedUserArray.index(of: user)
            cell.cultNameLabel.text = requestedCultArray[index!].cultName
            
        }else{
            cell.addButton.setTitle("ADD", for: .normal)
            cell.cultNameLabel.isHidden = true
        }
        
        cell.addButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    //Show cult list or cancle friend request
    
    func didAddButtonPressed(button: UIButton) {
        
        print(button)
        
        for user in requestedUserArray{
            print(user.userName)
        }
        print(userArray[button.tag].userName)
        
        if !requestedUserArray.contains(userArray[button.tag]){
            
            let vc: ChooseCultVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseCultVC") as! ChooseCultVC
            self.present(vc, animated: true, completion: nil)
            requestedUser = userArray[button.tag]
            
        }else{
            
            AppManager.shared.showLoadingIndicator(view: self.view)
            
            APIManager.shared.cancelFriendRequest(params: ["user_id": userArray[button.tag].id], token: UserDefaults.standard.string(forKey: TOKEN)!) { (error, response) in
                
                if error == nil{
                    
                    print(response)
                    
                    if response["result"].stringValue == "success"{
                        
                        if let index = self.requestedUserArray.index(of: self.userArray[button.tag]) {
                            self.requestedUserArray.remove(at: index)
                            self.requestedCultArray.remove(at: index)
                        }
                        
                        self.userTable.reloadData()
                        
                    }
                    
                }else{
                    
                    AppManager.shared.showAlert(title: "Oops!", msg: (error?.localizedDescription)!, activity: self)
                    
                }
                
                AppManager.shared.hideLoadingIndicator()
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Send friend request
        
        if self.presentedViewController != nil && self.presentedViewController!.isKind(of: ChooseCultVC.self){
            
            AppManager.shared.showLoadingIndicator(view: self.view)
            
            APIManager.shared.sendFriendRequest(params: ["cult_id": AppManager.shared.selectedCult.id, "user_id": requestedUser.id], token: UserDefaults.standard.string(forKey: TOKEN)!, completion: { (error, response) in
                
                if error == nil{
                    
                    print(response)
                    
                    if response["result"].stringValue == "success"{
                        
                        self.requestedUserArray.append(self.requestedUser)
                        self.requestedCultArray.append(AppManager.shared.selectedCult)
                        
                        self.userTable.reloadData()
                        
                    }
                    
                }else{
                    
                    AppManager.shared.showAlert(title: "Oops!", msg: (error?.localizedDescription)!, activity: self)
                    
                }
                
                AppManager.shared.hideLoadingIndicator()
                
            })
            
        }
        
    }
    
    @IBAction func onContinueButton(_ sender: Any) {
        
        AppManager.shared.goToMainTabBar()
        
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
    
    func setPlaceholder(textField: UITextField, placeholderString: String){
        
        textField.defaultTextAttributes.updateValue(1.5, forKey: NSAttributedStringKey.kern.rawValue)
        
        let string = NSMutableAttributedString(string: placeholderString)
        
        string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(rgb: 0x28375A) , range: NSRange(location:0,length: string.length))
        string.addAttribute(kCTKernAttributeName as NSAttributedStringKey, value: CGFloat(1), range: NSRange(location: 0, length: string.length))
        string.addAttributes([NSAttributedStringKey.font: UIFont(name: "Roboto-Regular", size: 16.0)!], range: NSRange(location: 0, length: string.length))
        
        textField.attributedPlaceholder = string
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
