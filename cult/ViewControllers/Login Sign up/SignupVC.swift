//
//  SignupVC.swift
//  Cult
//
//  Created by Han on 5/22/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import MBProgressHUD
import Alamofire
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class SignupVC: UIViewController, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var avoidingView: UIView!
    
    var photoImage: UIImage? = nil
    
    var genderPickerView: UIPickerView!
    
    var genderArray = ["Male", "Female", "Other"]
    var selectedGender: String!
    var strImageUrl = "";
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppManager.shared.setBorderToUIView(view: signupButton, width: 1, color: UIColor.init(rgb: 0x21283B))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonTap(_:)))
        backButton.addGestureRecognizer(tap)

        //set place holder text and color for first name and password
        
        setPlaceholder(textField: firstnameTextField, placeholderString: "First Name")
        setPlaceholder(textField: lastnameTextField, placeholderString: "Last Name")
        
        //set bottom border
        
        setBottomBorder(sender: firstnameTextField)
        setBottomBorder(sender: lastnameTextField)
        
        setPlaceholder(textField: usernameTextField, placeholderString: "USERNAME")
        setPlaceholder(textField: emailTextField, placeholderString: "EMAIL ADDRESS")
        setPlaceholder(textField: passwordTextField, placeholderString: "PASSWORD")
        setPlaceholder(textField: genderTextField, placeholderString: "GENDER")
        setPlaceholder(textField: birthdayTextField, placeholderString: "BIRTHDAY")
        
        KeyboardAvoiding.avoidingView = avoidingView
        
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        genderTextField.delegate = self
        birthdayTextField.delegate = self
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.photoImageViewTap(_:)))
        photoImageView.addGestureRecognizer(tap1)
        
        
//        firstnameTextField.text = "dfdf"
//        lastnameTextField.text = "sdfsdf"
//        usernameTextField.text = "ewrads"
//        emailTextField.text = "xcvxcv@oipo.com"
//        passwordTextField.text = "123456"
//        genderTextField.text = "Male"
//        birthdayTextField.text = "2018-09-24"
        
        
        //set bottom text
        
//        bottomTextView.textContainerInset = UIEdgeInsets.zero
//        bottomTextView.textContainer.lineFragmentPadding = 0
//        
//        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "BY TAPPING SIGN UP & ACCEPT, YOU AGREE TO THE\nTERMS OF SERVICE AND PRIVACY POLICY")
//        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(rgb: 0x098597) , range: NSMakeRange(0, attributedString.length))
//        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 10.7, weight: .light), range: NSMakeRange(0, attributedString.length))
//        
//        let termsLink = attributedString.setAsLink(textToFind: "TERMS OF SERVICE", linkURL: "https://www.google.com/")
//        
//        if termsLink {
//            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 10.7), range: NSMakeRange(46, 16))
//        }
//        
//        let privacyLink = attributedString.setAsLink(textToFind: "PRIVACY POLICY", linkURL: "https://www.google.com/")
//        
//        if privacyLink {
//            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 10.7), range: NSMakeRange(67, 14))
//        }
//        
//        UITextView.appearance().linkTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: UIColor.init(rgb: 0x098597) ]
//        
//        bottomTextView.attributedText = attributedString
//        bottomTextView.textAlignment = .center
        
        
    }
    
    //show camera/photo gallery options sheet
    
    @objc func photoImageViewTap(_ sender: UITapGestureRecognizer) {
        
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
        photoImageView.image = photoImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setPlaceholder(textField: UITextField, placeholderString: String){
        
        textField.defaultTextAttributes.updateValue(1.5, forKey: NSAttributedStringKey.kern.rawValue)
        
        let string = NSMutableAttributedString(string: placeholderString)
        
        string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white , range: NSRange(location:0,length: string.length))
        string.addAttribute(kCTKernAttributeName as NSAttributedStringKey, value: CGFloat(1.5), range: NSRange(location: 0, length: string.length))
        string.addAttributes([NSAttributedStringKey.font: UIFont(name: "Roboto-Regular", size: 13.0)!], range: NSRange(location: 0, length: string.length))
        
        textField.attributedPlaceholder = string
        
    }
    
    @objc func backButtonTap(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setBottomBorder(sender: UITextField){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.init(rgb: 0x134358).cgColor
        border.frame = CGRect(x: 0, y: sender.frame.size.height - width, width:  sender.frame.size.width, height: sender.frame.size.height)

        border.borderWidth = width
        sender.layer.addSublayer(border)
        sender.layer.masksToBounds = true
    }

    @IBAction func birthdayEditingDidBegin(_ sender: Any) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -13, to: Date())
        (sender as! UITextField).inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(self.dismissPicker))
        birthdayTextField.inputAccessoryView = toolBar

    }
    
    @IBAction func genderEditingDidBegin(_ sender: Any) {
        
        self.genderPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
        self.genderPickerView.backgroundColor = UIColor.white
        genderTextField.inputView = self.genderPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        genderTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick() {
        genderTextField.text = selectedGender
        genderTextField.resignFirstResponder()
    }
//    @objc func cancelClick() {
//        genderPickerView.resignFirstResponder()
//    }
    
    @objc func dismissPicker() {
        
        birthdayTextField.resignFirstResponder()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderArray[row]
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthdayTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func onSignupButton(_ sender: Any) {
        
        //check validation for input fields.
        
        if  usernameTextField.text == "" ||
            firstnameTextField.text == "" ||
            lastnameTextField.text == "" ||
            emailTextField.text == "" ||
            birthdayTextField.text == "" ||
            passwordTextField.text == "" ||
            genderTextField.text == "" {
            
            AppManager.shared.showAlert(title: "Oops!", msg: "All fields are required.", activity: self)
            return
        }
        
        if !isValidEmail(testStr: emailTextField.text!){
            AppManager.shared.showAlert(title: "Oops!", msg: "Invalid email address.", activity: self)
            return
        }

        if (passwordTextField.text?.count)! < 6{
            AppManager.shared.showAlert(title: "Oops!", msg: "Password must be at least 6 letters", activity: self)
            return
        }

        //register user
        
        AppManager.shared.showLoadingIndicator(view: self.view)
        self.checkUsername()
        
        /*
        self.uploadPhoto()
        APIManager.shared.singUp(params: params) { (error, response) in
            
            if error == nil{

                if response["result"].stringValue == "success"{
                    
                    //signup success
                    
                    UserDefaults.standard.setValue(response["authToken"].stringValue, forKey: TOKEN)
                    UserDefaults.standard.set(true, forKey: ISLOGGEDIN)
                    
                    let user: UserModel = UserModel.init(jsonData: response["user"])
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
                    UserDefaults.standard.set(encodedData, forKey: USER_DATA)
        
                    //upload profile photo
                    
                    self.uploadPhoto()
                    
                }else{
                    
                    //signup failure
                    
                    let msg = response["msg"].dictionaryObject
                    
                    var errorMessage: String = ""
                    
                    print(msg!.values)
                    
                    for msgArray in msg!.values{
                        for msg in (msgArray as! [String]){
                            errorMessage += msg
                            errorMessage += "\n"
                        }
                    }
                
                    AppManager.shared.hideLoadingIndicator()
                    AppManager.shared.showAlert(title: "Oops!", msg: errorMessage, activity: self)
                }
                
            }else{

                AppManager.shared.hideLoadingIndicator()
                AppManager.shared.showAlert(title: "Oops!", msg: error!.localizedDescription, activity: self)
                
            }
            
        }
 */
        
    }

    
    //Check Username exist
    func checkUsername(){
        self.ref.child("users").child(self.usernameTextField.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if(value != nil){
                AppManager.shared.hideLoadingIndicator()
                AppManager.shared.showAlert(title: "Oops!", msg: "Username is Already Exist", activity: self)
            }
            else{
                self.uploadPhoto()
            }
            
        }) { (error) in
            AppManager.shared.hideLoadingIndicator()
            AppManager.shared.showAlert(title: "Signup Failed", msg: "Try again later.", activity: self)
            print(error.localizedDescription)
        }
    }
    
    //Upload photo
    func uploadPhoto(){
        if photoImage != nil{
            var data = NSData()
            data = UIImageJPEGRepresentation(photoImage!, 0.3)! as NSData
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            // set upload path
            
            
            let imageName = usernameTextField.text!
            let storeImage = self.storageRef.child("profile_Images").child(imageName)
            storeImage.putData(data as Data, metadata: metaData, completion: { (metaData, error) in
                storeImage.downloadURL(completion: { (url, error) in
                    if let urlText = url?.absoluteString {
                        self.strImageUrl = urlText
                        self.doSignup()
                    }
                    else{
                        print(error)
                        AppManager.shared.hideLoadingIndicator()
                        AppManager.shared.showAlert(title: "Signup Failed", msg: "Try again later.", activity: self)
                    }
                })
            })
            
//            storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
//                storeImage.downloadURL(completion: { (url, error) in
//                    if let urlText = url?.absoluteString {
//
//                        strURL = urlText
//                        print("///////////tttttttt//////// \(strURL)   ////////")
//
//                        completion(strURL)
//                    }
//                })
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }else{
//                    //store downloadURL
//                    let downloadURL = metaData!.downloadURL()!.absoluteString
//                    print(downloadURL)
//                    //store downloadURL at database
////                    self.databaseRef.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
//                }
//
//            }
            
//            APIManager.shared.profilePhotoUpload(params: ["image": AppManager.shared.convertImageToBase64(image: photoImageView.image!)], token: UserDefaults.standard.string(forKey: TOKEN)!) { (error, response) in
//
//                if error == nil{
//                    print(response)
//                    let user: UserModel = UserModel.init(jsonData: response["user"])
//                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
//                    UserDefaults.standard.set(encodedData, forKey: USER_DATA)
//                }else{
//                    print(error!.localizedDescription)
//                }
//
//                AppManager.shared.hideLoadingIndicator()
//                self.performSegue(withIdentifier: "FindFriendRequestSegue", sender: self)
//
//            }
            
        }else{
            self.doSignup()
        }
    }
    func doSignup(){
        Auth.auth().createUser(withEmail:  emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                AppManager.shared.hideLoadingIndicator()
                AppManager.shared.showAlert(title: "Signup Failed", msg: "Try again later.", activity: self)
            }
            else if let user = user {
                print("Sign Up Successfully. \(user.uid)")
                let genderIndex: Int!
                
                if self.genderTextField.text == "Male"{
                    genderIndex = 0
                }else if self.genderTextField.text == "Female"{
                    genderIndex = 1
                }else{
                    genderIndex = 2
                }
                
                let params = ["username": self.usernameTextField.text!,
                              "first_name": self.firstnameTextField.text!,
                              "last_name": self.lastnameTextField.text!,
                              "email": self.emailTextField.text!,
                              "birth": self.birthdayTextField.text!,
                              "role": 0,
                              "password": self.passwordTextField.text!,
                              "avatar":self.strImageUrl,
                              "gender": genderIndex,
                              "uid":user.uid] as NSDictionary
                self.ref.child("users").child(self.usernameTextField.text!).setValue(params)
                AppManager.shared.hideLoadingIndicator()
                
                let user: UserModel = UserModel.init(jsonData: params)
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
                UserDefaults.standard.set(encodedData, forKey: USER_DATA)
                
                self.performSegue(withIdentifier: "FindFriendRequestSegue", sender: self)
            }
        }
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.firstnameTextField {
            self.lastnameTextField.becomeFirstResponder()
        }else if textField == self.lastnameTextField {
            usernameTextField.becomeFirstResponder()
        }else if textField == self.usernameTextField {
            emailTextField.becomeFirstResponder()
        }else if textField == self.emailTextField {
            passwordTextField.becomeFirstResponder()
        }else if textField == self.passwordTextField {
            genderTextField.becomeFirstResponder()
        }else{
            birthdayTextField.becomeFirstResponder()
        }

        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}


