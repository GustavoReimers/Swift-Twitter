//
//  AllCultVC.swift
//  Cult
//
//  Created by Han on 6/2/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import Alamofire

class AllCultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cultTable: UITableView!
    @IBOutlet weak var allCultButton: UIButton!
    @IBOutlet weak var backButton: UIImageView!
    
    var cultArray: [CultModel] = []
    var selectionArray: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cultTable.delegate = self
        cultTable.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonTap(_:)))
        backButton.addGestureRecognizer(tap)
        
        AppManager.shared.setBorderToUIView(view: allCultButton, width: 1, color: UIColor.init(rgb: 0x21283B))
        
        AppManager.shared.showLoadingIndicator(view: self.view)
        
        APIManager.shared.fetchCults(params: [:], token: UserDefaults.standard.string(forKey: TOKEN)!) { (error, response) in
            
            if error == nil{

                let cults = response["cults"].array
                
                for cult in cults!{
                    
                    let data = CultModel.init(jsonData: cult)
                    self.cultArray.append(data)
                    self.selectionArray.append(false)
                    
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
        
        if selectionArray[indexPath.row] == true{
            cell.cultNameLabel.textColor = UIColor.init(rgb: 0x157382)
        }else{
            cell.cultNameLabel.textColor = UIColor.white
        }
        
        cell.cultNameLabel.letterSpace = 1.5
        
        cell.bgView.layer.borderWidth = 1
        cell.bgView.layer.borderColor = UIColor.init(rgb: 0x28375A).cgColor
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectionArray[indexPath.row] = selectionArray[indexPath.row] == false ? true : false
        
        tableView.reloadData()
    }

    @IBAction func onDoneButton(_ sender: Any) {
        
        AppManager.shared.selectedCultsForPost.removeAll()
        
        for i in 0..<selectionArray.count{
            
            if selectionArray[i] == true{
                AppManager.shared.selectedCultsForPost.append(cultArray[i])
            }
            
        }
        
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onAllCultButton(_ sender: Any) {
        
        selectionArray.removeAll()
        for _ in cultArray{
            selectionArray.append(true)
        }
        
        self.cultTable.reloadData()
        
    }
    
    @objc func backButtonTap(_ sender: UITapGestureRecognizer) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
