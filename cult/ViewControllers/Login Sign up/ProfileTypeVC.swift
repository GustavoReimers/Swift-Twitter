//
//  ProfileTypeVC.swift
//  Cult
//
//  Created by Han on 5/5/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit

class ProfileTypeVC: UIViewController {

    @IBOutlet weak var chooseButton: UIButton!
    
    @IBOutlet weak var personalView: UIView!
    @IBOutlet weak var personalImageView: UIImageView!
    
    @IBOutlet weak var artistView: UIView!
    @IBOutlet weak var artistImageView: UIImageView!
    
    @IBOutlet weak var lblPersonal: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    
    @IBOutlet weak var backButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppManager.shared.setBorderToUIView(view: chooseButton, width: 1, color: UIColor.init(rgb: 0x21283B))
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        personalView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        artistView.addGestureRecognizer(tap2)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonTap(_:)))
        backButton.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        if sender.view == personalView{
            
            personalImageView.image = UIImage.init(named: "personal_profile_type_highlighted")
            artistImageView.image = UIImage.init(named: "artist_profile_type")
            
            lblPersonal.textColor = UIColor.init(rgb: 0x098597)
            lblArtist.textColor = UIColor.white
            
            AppManager.shared.accountType = 0
            
        }else{
            
            personalImageView.image = UIImage.init(named: "personal_profile_type")
            artistImageView.image = UIImage.init(named: "artist_profile_type_highlighted")
            
            lblPersonal.textColor = UIColor.white
            lblArtist.textColor = UIColor.init(rgb: 0x098597)
            
            AppManager.shared.accountType = 1
            
        }
        
    }
    
    @IBAction func onChooseButton(_ sender: Any) {
        
        if AppManager.shared.accountType == 0{
        
            self.performSegue(withIdentifier: "SignupSegue", sender: nil)
            
        }
        
    }
    
    @objc func backButtonTap(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

extension UILabel {
    
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            
            attributedString.addAttribute(kCTKernAttributeName as NSAttributedStringKey,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = attributedText?.attribute(kCTKernAttributeName as NSAttributedStringKey, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}

extension UIButton {
    
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedTitle(for: .normal) {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
                setTitle(.none, for: .normal)
            }
            
            attributedString.addAttribute(kCTKernAttributeName as NSAttributedStringKey,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            
            setAttributedTitle(attributedString, for: .normal)
        }
        
        get {
            if let currentLetterSpace = attributedTitle(for: .normal)?.attribute(kCTKernAttributeName as NSAttributedStringKey, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}



