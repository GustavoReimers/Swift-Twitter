//
//  HomeVC.swift
//  Cult
//
//  Created by iOS Developer on 6/12/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import GrowingTextView
import FirebaseStorage
import FirebaseDatabase

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    var refreshControl = UIRefreshControl()
    
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference();
    var postArray: [PostModel] = []
    var user:UserModel? = nil
    
    @IBOutlet weak var table_posts: UITableView!
    override func viewDidLoad() {
        AppManager.shared.showLoadingIndicator(view: self.view)
        self.table_posts.delegate = self;
        self.table_posts.dataSource = self;
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:[NSAttributedStringKey.foregroundColor:UIColor.green])
        self.refreshControl.addTarget(self, action: #selector(reloadPosts), for: UIControlEvents.valueChanged)
        self.refreshControl.tintColor = UIColor.green
        self.table_posts.addSubview(self.refreshControl)
        
        let decoded = UserDefaults.standard.object(forKey: USER_DATA) as! Data
        self.user = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? UserModel
        self.getPosts()
    }
    @objc func reloadPosts(_ sender:Any){
        self.getPosts()
    }
    func getPosts(){
        
        self.ref.child("posts").queryOrdered(byChild: "user_name").queryEqual(toValue: self.user?.userName).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if(value != nil){
                self.postArray.removeAll()
                var sortedKeys = value?.allKeys as? [String]
                sortedKeys?.sort(by: { (a, b) -> Bool in
                    return Int64(a)! > Int64(b)!
                })
                for(key) in sortedKeys!{
                    var item = value?.value(forKey: key)
                    let data = PostModel.init(jsonData: item as! NSDictionary)
                    self.postArray.append(data)
                }
                self.table_posts.reloadData()
                AppManager.shared.hideLoadingIndicator()
                self.refreshControl.endRefreshing()
            }
            else{
                AppManager.shared.hideLoadingIndicator()
                self.refreshControl.endRefreshing()
               
            }
            
        }) { (error) in
            AppManager.shared.hideLoadingIndicator()
            self.refreshControl.endRefreshing()
            print(error.localizedDescription)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postcell", for: indexPath) as! PostImageCell
        //Caption and user name
        cell.label_content.text = self.postArray[indexPath.row].tx_caption
        cell.label_name.text = self.postArray[indexPath.row].tx_name
        
        //Date Formatter
        let dateVar = Date(timeIntervalSince1970: self.postArray[indexPath.row].nTimeMili/1000)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy hh:mm"
        cell.label_time.text = dateFormatter.string(from: dateVar)
        
        //user avatar
        cell.img_profile.sd_setImage(with: URL.init(string: self.postArray[indexPath.row].img_avatar), placeholderImage: UIImage.init(named: "person-placeholder"), options: .refreshCached)
        
        cell.img_post.sd_setImage(with: URL.init(string: self.postArray[indexPath.row].img_url), placeholderImage: UIImage.init(named: "person-placeholder"), options: .refreshCached)
        return cell
    }
}
