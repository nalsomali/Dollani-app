//
//  EditCGprofileViewController.swift
//  Dollani
//
//  Created by Sara on 26/12/2022.
//

import UIKit
import Firebase

class EditCGprofileViewController: UIViewController, UITextFieldDelegate,UINavigationBarDelegate {
    //Text fields
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    
    //save button
    @IBOutlet weak var saveButton: UIButton!

    //Error messages
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var phoneNumError: UILabel!

    @IBOutlet weak var navBar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        phoneNum.delegate = self
        navBar.delegate = self
        
        
        saveButton.isEnabled = false
        
        retriveUserInfo()
    }
    func checkForValidForm()
        {
            if  nameError.isHidden &&  phoneNumError.isHidden
            {
                saveButton.isEnabled = true
            }
            else
            {
                saveButton.isEnabled = false
            }
        }
    func retriveUserInfo(){
        let user = Auth.auth().currentUser
        if let user = user {
            
            let currentEmail = user.email
            print(currentEmail! )
            Firestore.firestore().collection("users").whereField("email",isEqualTo:currentEmail!).getDocuments { snapshot, error in
                if  error != nil {
                    // ERROR
                }
                else {
                    if(snapshot?.count != 0){
                        
                        let userName = snapshot?.documents.first?.get("name") as! String
                        let userPhoneNum = snapshot?.documents.first?.get("phoneNum") as! String
                        
                        
                        //Set textView
                        self.name.text = userName
                        self.phoneNum.text = userPhoneNum                           }
                }
            }
            
            // ...
        }
    }
               
       
        @IBAction func nameField(_ sender: Any) {
            if let name = name.text
                    {
                        if let errorMessage = invalidName(name)
                        {
                            nameError.text = errorMessage
                            nameError.isHidden = false
                        }
                        else
                        {
                            nameError.isHidden = true
                        }
                    }
                    checkForValidForm()
        }
    
        func invalidName(_ value: String) -> String?
            {
                if(value == "" || value.trimmingCharacters(in: .whitespaces) == ""){
                    return "مطلوب"
                }
                let set = CharacterSet(charactersIn: value)
                if CharacterSet.decimalDigits.isSuperset(of: set)
                {
                    return "يجب ان يتكون الاسم من احرف فقط"
                }
               
                return nil    }
        
        
        @IBAction func phoneField(_ sender: Any) {
            if let phoneNumber = phoneNum.text
                    {
                        if let errorMessage = invalidPhoneNumber(phoneNumber)
                        {
                            phoneNumError.text = errorMessage
                            phoneNumError.isHidden = false
                        }
                        else
                        {
                            phoneNumError.isHidden = true
                        }
                    }
                    checkForValidForm()
        }
        func invalidPhoneNumber(_ value: String) -> String?
            {
                
                if(value == "" || value.trimmingCharacters(in: .whitespaces) == ""){
                    return "مطلوب"
                }
                if !validatePhoneNum(value: value)
                {
                    return "رقم الهاتف غير صحيح"
                }
                
               
                return nil
            }
        func validatePhoneNum(value: String) -> Bool {
            let PHONE_REGEX = "^((05))[0-9]{8}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: value)
            return result
        }

        
        
        @IBAction func saveTapped(_ sender: Any) {
            //get data
            guard let Name = name.text else {return}
            guard let Phone = phoneNum.text else {return}
            //update
            let user = Auth.auth().currentUser
            if let user = user {
                
                let currentEmail = user.email
                Firestore.firestore().collection("users").document(currentEmail!).updateData(["name":Name, "phoneNum":Phone]) }
            //alert
            let alert = UIAlertController(title: nil, message:"تم حفظ التغييرات بنجاج", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:  "حسنًا", style: .default, handler:nil))
           present(alert, animated: true, completion: nil)
            
            /*
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "VIcontainer")
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
            */

        }
        
        
        @IBAction func cancelTapped(_ sender: Any) {
            
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "CGcontainer")
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true)
        }
        
        
        @IBAction func backButton(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "CGcontainer")
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
        func position(for bar: UIBarPositioning) -> UIBarPosition {
         return .topAttached
        }
  // Do any additional setup after loading the view.
    }
