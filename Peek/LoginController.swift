//
//  ViewController.swift
//  Peek
//
//  Created by Chris Norman on 3/19/18.
//  Copyright © 2018 Chris Norman. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Peek"))
        logoImageView.contentMode = .center
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
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
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 169, green: 169, blue: 248)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.rgb(red: 169, green: 169, blue: 248), for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    let forgotPassButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.rgb(red: 169, green: 169, blue: 248), for: .normal)
        button.addTarget(self, action: #selector(handlePassReset), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        setupInputFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValid{
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 103, green: 174, blue: 202)
        }else {
            loginButton.isEnabled = false
            loginButton.backgroundColor =  UIColor.rgb(red: 103, green: 174, blue: 202)
        }
    }
    
    @objc func handleLogIn() {
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: pass) { (user, err) in
            
            if let err = err {
                print("Failed to log in user with error: ", err)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let db = Firestore.firestore()
            db.collection("users").getDocuments{ (qs, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for doc in qs!.documents {
                        let ref = doc.data()
                        print(ref.first)
                    }
                }
            }
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setUpSerControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handlePassReset() {
        guard let email = emailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            print("Your password has been successfully reset")
        }
    }
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton,signUpButton,forgotPassButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 400)
        
        
    }


}

