//
//  PhotoPostVC.swift
//  Cult
//
//  Created by Han on 5/31/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import GrowingTextView

class PhotoPostVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var captionTextField: GrowingTextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var allCultButton: UIButton!
    @IBOutlet weak var backButton: UIImageView!
    
    var postImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppManager.shared.makeCircleToUIView(view: profilePhotoImageView)
        AppManager.shared.setBorderToUIView(view: allCultButton, width: 1, color: UIColor.init(rgb: 0x21283B))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonTap(_:)))
        backButton.addGestureRecognizer(tap)
        
        let decoded = UserDefaults.standard.object(forKey: USER_DATA) as! Data
        let user = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserModel
        
        let maskPath = UIBezierPath(roundedRect: postImageView.bounds,
                                    byRoundingCorners: [.bottomLeft, .topRight],
                                    cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        postImageView.layer.mask = shape

        captionTextField.delegate = self
        
        postImageView.image = postImage
        
        profilePhotoImageView.sd_setImage(with: URL.init(string: user.profileImageUrl), placeholderImage: UIImage.init(named: "person-placeholder"), options: .refreshCached) { (image, error, cacheType, url) in
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
        
        if AppManager.shared.selectedCultsForPost.count == 0{
            AppManager.shared.showAlert(title: "Oops!", msg: "Please select cults.", activity: self)
            return
        }
        
        AppManager.shared.showLoadingIndicator(view: self.view)
        
        var cultIds: [Int] = []
        for cult in AppManager.shared.selectedCultsForPost{
            cultIds.append(cult.id)
        }
        
        let params = ["image": AppManager.shared.convertImageToBase64(image: postImage!),
                      "caption": captionTextField.text,
                      "cult_ids": cultIds] as [String: Any]
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
