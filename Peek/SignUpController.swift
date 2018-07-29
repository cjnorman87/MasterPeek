//
//  SignUpController.swift
//  Peek
//
//  Created by Chris Norman on 3/27/18.
//  Copyright © 2018 Chris Norman. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isSwitchOn: Bool = false
    
    let signUpLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Sign Up"
        lb.font = UIFont.systemFont(ofSize: 36)
        lb.textColor = UIColor.rgb(red: 169, green: 169, blue: 248)
        return lb
    }()

    let emailTextField: UITextField = {
        let Tf = UITextField()
        Tf.placeholder = "email"
        Tf.backgroundColor = UIColor(white:0, alpha: 0.03)
        Tf.borderStyle = .roundedRect
        Tf.font = UIFont.systemFont(ofSize: 14)
        Tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return Tf
    }()

    let usernameTextField: UITextField = {
        let Tf = UITextField()
        Tf.placeholder = "username"
        Tf.backgroundColor = UIColor(white:0, alpha: 0.03)
        Tf.borderStyle = .roundedRect
        Tf.font = UIFont.systemFont(ofSize: 14)
        Tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return Tf
    }()
    
    let passwordTextField: UITextField = {
        let Tf = UITextField()
        Tf.placeholder = "password"
        Tf.isSecureTextEntry = true
        Tf.backgroundColor = UIColor(white:0, alpha: 0.03)
        Tf.borderStyle = .roundedRect
        Tf.font = UIFont.systemFont(ofSize: 14)
        Tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return Tf
    }()

    let PhoneTextField: UITextField = {
        let Tf = UITextField()
        Tf.placeholder = "Phone"
        Tf.isSecureTextEntry = true
        Tf.backgroundColor = UIColor(white:0, alpha: 0.03)
        Tf.borderStyle = .roundedRect
        Tf.font = UIFont.systemFont(ofSize: 14)
        Tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return Tf
    }()
    
    let companyTextField: UITextField = {
        let Tf = UITextField()
        Tf.placeholder = "Company Name"
        Tf.isSecureTextEntry = true
        Tf.backgroundColor = UIColor(white:0, alpha: 0.03)
        Tf.borderStyle = .roundedRect
        Tf.font = UIFont.systemFont(ofSize: 14)
        Tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return Tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 169, green: 169, blue: 248)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let profileSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
        return sw
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.backgroundColor = .white
        
        view.addSubview(signUpLabel)
        signUpLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        setupInputFields(isItOn: false)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let username = usernameTextField.text, username.count > 0 else {return}
        guard let pass = passwordTextField.text, pass.count > 0 else {return}
        guard let phone = PhoneTextField.text, pass.count > 0 else {return}
        guard let co = companyTextField.text, pass.count > 0 else {return}
        let isRec = String(profileSwitch.isOn)
        Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
            if let err = error{
                print("Cj: this is the errer", err)
                return
            }
                guard let uid = user?.uid else { return }
                let db = Firestore.firestore()
                let settings = db.settings
                settings.areTimestampsInSnapshotsEnabled = true
                db.settings = settings
                var ref: DocumentReference? = nil
                let dictionaryValues = ["username" : username,"phone" : phone,"company" : co,"recruiter" : isRec]
                let values = [uid: dictionaryValues]
                if isRec == "true"{
                ref = db.collection("users").addDocument(data: values) {
                      err in
                    if let err = err {
                        print("Error adding doc: \(err)")
                    } else {
                        print("Doc added w/ ID: \(ref!.documentID)")
                        }
                    }
                Database.database().reference().child("rusers").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if let err = error {
                        print("Failed to save user info into db:", err)
                        return
                    }
                    print("Successfully saved user info to DB")
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setUpSerControllers()
                    self.dismiss(animated: true, completion: nil)
                })
                } else {
                    ref = db.collection("users").addDocument(data: values) {
                        err in
                        if let err = err {
                            print("Error adding doc: \(err)")
                        } else {
                            print("Doc added w/ ID: \(ref!.documentID)")
                        }
                    }
                    Database.database().reference().child("susers").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if let err = error {
                            print("Failed to save user info into db:", err)
                            return
                        }
                        print("Successfully saved user info to DB")
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        mainTabBarController.setUpRecControllers()
                        self.dismiss(animated: true, completion: nil)
                    })
            }
        }
    }
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValid{
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor =  UIColor.rgb(red: 169, green: 169, blue: 248)
        }
    }
    
    @objc func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }

    @objc func handleSwitch(_ sender: UISwitch!) {
        if sender.isOn {
            profileSwitch.setOn(true, animated: true)
            isSwitchOn = true
            setupInputFields(isItOn: isSwitchOn)
        } else {
            profileSwitch.setOn(false, animated: true)
            isSwitchOn = false
            setupInputFields(isItOn: isSwitchOn)
        }
    }
    
    fileprivate func setupInputFields(isItOn: Bool) {
        if isItOn {
            hideFields()
        } else {
            showFields()
        }
    }

    fileprivate func showFields() {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField,emailTextField,PhoneTextField,passwordTextField,companyTextField,profileSwitch,signUpButton])
        PhoneTextField.isHidden = false
        companyTextField.isHidden = false
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 40
        
        view.addSubview(stackView)

        stackView.anchor(top: signUpLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 500)
    }
    
    fileprivate func hideFields() {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField,emailTextField,PhoneTextField,passwordTextField,companyTextField,profileSwitch,signUpButton])
        PhoneTextField.isHidden = true
        companyTextField.isHidden = true
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 40
        
        view.addSubview(stackView)
        
        stackView.anchor(top: signUpLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 500)
    }
}
