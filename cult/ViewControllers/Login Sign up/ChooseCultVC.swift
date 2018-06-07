//
//  ChooseCultVC.swift
//  Cult
//
//  Created by Han on 5/22/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import Alamofire

class ChooseCultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cultTable: UITableView!
    @IBOutlet weak var addNewCultButton: UIButton!
    
    var cultArray: [CultModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cultTable.delegate = self
        cultTable.dataSource = self
        AppManager.shared.setBorderToUIView(view: addNewCultButton, width: 1, color: UIColor.init(rgb: 0x21283B))
        
        AppManager.shared.showLoadingIndicator(view: self.view)

        APIManager.shared.fetchCults(params: [:], token: UserDefaults.standard.string(forKey: TOKEN)!) { (error, response) in
            
            if error == nil{
                
                print(response)
                
                let cults = response["cults"].array
                
                for cult in cults!{
                    
                    let data = CultModel.init(jsonData: cult)
                    self.cultArray.append(data)
                    
                }
                
                self.cultTable.reloadData()
                
            }else{
                
                print(error!.localizedDescription)
                
            }
            
            AppManager.shared.hideLoadingIndicator()
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cultArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ChooseCultCell = tableView.dequeueReusableCell(withIdentifier: "ChooseCultCell") as! ChooseCultCell
        
        let cult = cultArray[indexPath.row]
        
        cell.cultNameLabel.text = cult.cultName
        cell.cultNameLabel.letterSpace = 1.5
        
        cell.bgView.layer.borderWidth = 1
        cell.bgView.layer.borderColor = UIColor.init(rgb: 0x28375A).cgColor
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AppManager.shared.selectedCult = cultArray[indexPath.row]
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onAddNewCultButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Name Your Cult", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Type the name"
            textField.autocapitalizationType = .allCharacters
        }
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            let cultTextField = alertController.textFields![0] as UITextField
            
            print(cultTextField.text!)
            
            AppManager.shared.showLoadingIndicator(view: self.view)
            
            APIManager.shared.addNewCult(params: ["cultname": cultTextField.text!], token: UserDefaults.standard.string(forKey: TOKEN)!, completion: { (error, response) in
                
                if error == nil{
                    
                    print(response)
                    
                    if response["result"].stringValue == "success"{
                        
                        let cults = response["cults"].array
                        self.cultArray.removeAll()
                        
                        for cult in cults!{
                            
                            let data = CultModel.init(jsonData: cult)
                            self.cultArray.append(data)
                            
                        }
                        
                        self.cultTable.reloadData()
                        
                    }
                    
                }else{
                    
                    AppManager.shared.showAlert(title: "Oops!", msg: (error?.localizedDescription)!, activity: self)
                    
                }
                
                AppManager.shared.hideLoadingIndicator()
                
            })
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
