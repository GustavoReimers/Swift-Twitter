//
//  PhotoPostVC.swift
//  Cult
//
//  Created by Han on 5/31/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import GrowingTextView
import FirebaseStorage
import FirebaseDatabase

class PhotoPostVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var captionTextField: GrowingTextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var allCultButton: UIButton!
    @IBOutlet weak var backButton: UIImageView!
    
    var postImage: UIImage!
    
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference();
    var user:UserModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppManager.shared.makeCircleToUIView(view: profilePhotoImageView)
        AppManager.shared.setBorderToUIView(view: allCultButton, width: 1, color: UIColor.init(rgb: 0x21283B))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonTap(_:)))
        backButton.addGestureRecognizer(tap)
        
        let decoded = UserDefaults.standard.object(forKey: USER_DATA) as! Data
        self.user = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? UserModel
        

        
    }
    override func viewDidLayoutSubviews() {
        let maskPath = UIBezierPath(roundedRect: postImageView.bounds,
                                    byRoundingCorners: [.bottomLeft, .topRight],
                                    cornerRadii: CGSize(width: 20.0, height: 20.0))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        postImageView.layer.mask = shape
        
        captionTextField.delegate = self
        
        postImageView.image = postImage
        
        profilePhotoImageView.sd_setImage(with: URL.init(string: (user?.profileImageUrl)!), placeholderImage: UIImage.init(named: "person-placeholder"), options: .refreshCached) { (image, error, cacheType, url) in
            //do something
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        captionTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.presentedViewController != nil && self.presentedViewController!.isKind(of: AllCultVC.self){
            
            var titleString: String = ""
            for i in 0..<AppManager.shared.selectedCultsForPost.count{
                
                titleString += AppManager.shared.selectedCultsForPost[i].cultName
                
                if i != (AppManager.shared.selectedCultsForPost.count - 1){
                    titleString += ", "
                }
                
            }
            print(titleString)
            
//            allCultButton.setTitle(titleString, for: .normal)
//            allCultButton.letterSpace = 2
            
            let attributedString = NSMutableAttributedString(string: titleString)
            attributedString.addAttribute(kCTKernAttributeName as NSAttributedStringKey,
                                          value: allCultButton.letterSpace,
                                          range: NSRange(location: 0, length: attributedString.length))
            
            allCultButton.setAttributedTitle(attributedString, for: .normal)
            
        }
        
    }
    
    @IBAction func onAllCultButton(_ sender: Any) {
        
        let vc = AppManager.shared.getViewControllerWithId(id: "AllCultVC") as! AllCultVC
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func backButtonTap(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onShareButton(_ sender: Any) {
        
        if captionTextField.text == ""{
            AppManager.shared.showAlert(title: "Oops!", msg: "Please enter caption.", activity: self)
            return
        }
        
//        if AppManager.shared.selectedCultsForPost.count == 0{
//            AppManager.shared.showAlert(title: "Oops!", msg: "Please select cults.", activity: self)
//            return
//        }
        
        AppManager.shared.showLoadingIndicator(view: self.view)
        
        var cultIds: [String] = []
        for cult in AppManager.shared.selectedCultsForPost{
            cultIds.append(cult.uid)
        }
        
        var data = NSData()
        data = UIImageJPEGRepresentation(postImage!, 0.8)! as NSData
        // set upload path
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let imageName = "" + String(getCurrentMillis())
        let storeImage = self.storageRef.child("posts").child(imageName)
        
        storeImage.putData(data as Data, metadata: metaData, completion: { (metaData, error) in
            storeImage.downloadURL(completion: { (url, error) in
                if let urlText = url?.absoluteString {
                    let params = ["image":urlText,
                                  "caption":self.captionTextField.text,
                                  "cult_ids": cultIds,
                                  "uid":self.user?.uid ?? ""] as NSDictionary
                    self.ref.child("posts").child(imageName).setValue(params)
                    AppManager.shared.hideLoadingIndicator()
                    AppManager.shared.showAlert(title: "Posting Success", msg: "Your post successfully posted.", activity: self, complete: {
                    self.navigationController?.popViewController(animated: true)
                    });
                }
                else{
                    print(error ?? "")
                    AppManager.shared.hideLoadingIndicator()
                    AppManager.shared.showAlert(title: "Posting Failed", msg: "Try again later.", activity: self, complete: {
                        print("")
                    });
                }
            })
        })
        
        /*
        APIManager.shared.postPhoto(params: params, token: UserDefaults.standard.string(forKey: TOKEN)!) { (error, response) in
            
            print(response)
            
            if error == nil{
                
                if response["result"] == "success"{
                    AppManager.shared.showAlert(msg: "photo posted successfully", activity: self)
                }
                
            }else{
                
                AppManager.shared.showAlert(title: "Oops!", msg: error!.localizedDescription, activity: self)
                
            }
            
            AppManager.shared.hideLoadingIndicator()
        }
        */
    }
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
