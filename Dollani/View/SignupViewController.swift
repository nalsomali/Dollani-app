//
//  SignupViewController.swift
//  Dollani
//
//  Created by Alhanouf Alawwad on 16/05/1444 AH.
//


import UIKit
import Firebase



class SignupViewController: UIViewController {
    //Text fields
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conformedPassword: UITextField!
    @IBOutlet weak var category: UITextField!
    
    //signup button
    @IBOutlet weak var signupButton: UIButton!
    
    //Error messages
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var phoneNumError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var conformedPasswordError: UILabel!
    @IBOutlet weak var categoryError: UILabel!
    
    //Database reference
    let db = Firestore.firestore()
    
    let categoryList = ["ذوي اعاقة بصرية","مرافق"]
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        category.inputView = pickerView
        
        //Alignment
        name.textAlignment = .right
        phoneNum.textAlignment = .right
        email.textAlignment = .right
        password.textAlignment = .right
        conformedPassword.textAlignment = .right
        category.textAlignment = .right
        
        nameError.textAlignment = .right
        phoneNumError.textAlignment = .right
        emailError.textAlignment = .right
        passwordError.textAlignment = .right
        conformedPasswordError.textAlignment = .right
        categoryError.textAlignment = .right
    
        signupButton.isEnabled = false
    }
  
    func checkForValidForm()
        {
            if  nameError.isHidden &&  phoneNumError.isHidden &&  emailError.isHidden &&   passwordError.isHidden &&  conformedPasswordError.isHidden && categoryError.isHidden
            {
                signupButton.isEnabled = true
            }
            else
            {
                signupButton.isEnabled = false
            }
        }
    
    
    @IBAction func nameChanged(_ sender: Any) {
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
           
            return nil
        }
    @IBAction func phoneNumChanged(_ sender: Any) {
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
            
            let set = CharacterSet(charactersIn: value)
            if(value == "" || value.trimmingCharacters(in: .whitespaces) == ""){
                return "مطلوب"
            }
            if !CharacterSet.decimalDigits.isSuperset(of: set)
            {
                return "يجب أن يحتوي رقم الهاتف على أرقام فقط"
            }
            
            if value.count != 10
            {
                return "يجب أن يكون طول رقم الهاتف ١٠ أرقام"
            }
            return nil
        }
    @IBAction func emailChanged(_ sender: Any) {
        if let email = email.text
                {
                    if let errorMessage = invalidEmail(email)
                    {
                        emailError.text = errorMessage
                        emailError.isHidden = false
                    }
                    else
                    {
                        emailError.isHidden = true
                    }
                }
                
                checkForValidForm()
    }
    func invalidEmail(_ value: String) -> String?
        {
            let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            if(value == "" || value.trimmingCharacters(in: .whitespaces) == ""){
                return "مطلوب"
            }
            if !predicate.evaluate(with: value)
            {
                return "البريد الالكتروني غير صحيح"
            }
            
            return nil
        }
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let password = password.text
                {
                    if let errorMessage = invalidPassword(password)
                    {
                        passwordError.text = errorMessage
                        passwordError.isHidden = false
                    }
                    else
                    {
                        passwordError.isHidden = true
                    }
                }
                
                checkForValidForm()
    }
    func invalidPassword(_ value: String) -> String?
        {
            if(value == "" || value.trimmingCharacters(in: .whitespaces) == ""){
                return "مطلوب"
            }
            if value.count < 8
            {
                return "يجب أن تكون كلمة المرور ٨ أحرف على الأقل"
            }
            if containsDigit(value)
            {
                return " يجب أن تحتوي كلمة المرور على رقم واحد على الأقل"
            }
            if containsLowerCase(value)
            {
                return "يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل"
            }
            if containsUpperCase(value)
            {
                return "يجب أن تحتوي كلمة المرور على حرف واحد كبير على الأقل"
            }
            return nil
        }
    func containsDigit(_ value: String) -> Bool
        {
            let reqularExpression = ".*[0-9]+.*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            return !predicate.evaluate(with: value)
        }
        
        func containsLowerCase(_ value: String) -> Bool
        {
            let reqularExpression = ".*[a-z]+.*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            return !predicate.evaluate(with: value)
        }
        
        func containsUpperCase(_ value: String) -> Bool
        {
            let reqularExpression = ".*[A-Z]+.*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            return !predicate.evaluate(with: value)
        }
    
    @IBAction func confirmedPasswordChanged(_ sender: Any) {
        if let conformedPassword = conformedPassword.text
                {
                    if let errorMessage = invalidConformedPassword(conformedPassword)
                    {
                        conformedPasswordError.text = errorMessage
                        conformedPasswordError.isHidden = false
                    }
                    else
                    {
                        conformedPasswordError.isHidden = true
                    }
                }
                
                checkForValidForm()
    }
    func invalidConformedPassword(_ value: String) -> String?{
        if(value == "" || value.trimmingCharacters(in: .whitespaces) == ""){
            return "مطلوب"
        }
        if password.text != value{
            return "كلمة المرور لاتتطابق"
        }
        return nil
        
    }
    @IBAction func categoryChanged(_ sender: Any) {
        if category.text != ""{
            categoryError.isHidden = true
        }
       
        
        checkForValidForm()
        
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        guard let Name = name.text else {return}
        guard let Email = email.text else {return}
        guard let Phone = phoneNum.text else {return}
        guard let Password = password.text else {return}
        guard let Category = category.text else {return}
        
        
        Auth.auth().createUser(withEmail: Email, password: Password){firebaseResult,error in
            if let e = error{
                print(e.localizedDescription)
                if(e.localizedDescription  == "The email address is already in use by another account."){
                  //Alert message
                    let sendMailErrorAlert = UIAlertController(title: "خطاء", message: "يوجد حساب مسبق", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title:"تم", style: .cancel, handler: nil)

                        sendMailErrorAlert.addAction(cancelAction)
                    self.present(sendMailErrorAlert, animated: true, completion: nil)
                }
            }
            else{
                self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
                self.db.collection("users").addDocument(data: ["name" : Name,"phoneNum":Phone,"email":Email,"password":Password,"category":Category])
                
                self.name.text = ""
                self.email.text = ""
                self.phoneNum.text = ""
                self.password.text = ""
                self.conformedPassword.text = ""
                self.category.text = ""
                
               
            }
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
}

extension SignupViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category.text = categoryList[row]
        category.resignFirstResponder()
    }
    
    
}
