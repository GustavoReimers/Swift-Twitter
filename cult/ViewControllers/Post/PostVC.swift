//
//  PostVC.swift
//  Cult
//
//  Created by Han on 5/31/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var thoughtView: UIView!
    
    
    var photoImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppManager.shared.setBorderToUIView(view: videoView, width: 1, color: UIColor.init(rgb: 0x263654))
        AppManager.shared.setBorderToUIView(view: scrollView, width: 1, color: UIColor.init(rgb: 0x263654))
        AppManager.shared.setBorderToUIView(view: linkView, width: 1, color: UIColor.init(rgb: 0x263654))
        AppManager.shared.setBorderToUIView(view: musicView, width: 1, color: UIColor.init(rgb: 0x263654))
        AppManager.shared.setBorderToUIView(view: photoView, width: 1, color: UIColor.init(rgb: 0x263654))
        AppManager.shared.setBorderToUIView(view: thoughtView, width: 1, color: UIColor.init(rgb: 0x263654))
        
        AppManager.shared.makeCircleToUIView(view: videoView)
        AppManager.shared.makeCircleToUIView(view: scrollView)
        AppManager.shared.makeCircleToUIView(view: linkView)
        AppManager.shared.makeCircleToUIView(view: musicView)
        AppManager.shared.makeCircleToUIView(view: photoView)
        AppManager.shared.makeCircleToUIView(view: thoughtView)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        videoView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        scrollView.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        linkView.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        musicView.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        photoView.addGestureRecognizer(tap5)
        
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        thoughtView.addGestureRecognizer(tap6)
     
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        if sender.view == photoView{
            
            postPhoto()
            
        }
       
    }
    
    func postPhoto(){
    
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    //show camera
    
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    //show photo library
    
    func photoLibrary()
    {
        
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]) {
        
        photoImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.dismiss(animated: true) {
            let postPhotoVC = AppManager.shared.getViewControllerWithId(id: "PhotoPostVC") as! PhotoPostVC
            postPhotoVC.postImage = self.photoImage
            self.navigationController?.pushViewController(postPhotoVC, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
