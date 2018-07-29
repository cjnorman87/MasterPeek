//
//  VideoViewController.swift
//  Gazorpian
//
//  Created by Christopher Norman on 9/19/17.
//  Copyright © 2017 yakuza. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase

class VideoViewController: UIViewController, UITextFieldDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let typeField: UITextView = {
        let TV = UITextView()
        TV.keyboardAppearance = .dark
        TV.tintColor = UIColor.red
        TV.backgroundColor = UIColor.white
        TV.textColor = .white
        TV.font = .systemFont(ofSize: 32)
        return TV
    }()
    
    let benefitField: UITextView = {
        let TV = UITextView()
        TV.keyboardAppearance = .dark
        TV.tintColor = UIColor.red
        TV.backgroundColor = UIColor.white
        TV.textColor = .white
        TV.font = .systemFont(ofSize: 32)
        return TV
    }()
    
    let salaryField: UITextView = {
        let TV = UITextView()
        TV.keyboardAppearance = .dark
        TV.tintColor = UIColor.red
        TV.backgroundColor = UIColor.white
        TV.textColor = .white
        TV.font = .systemFont(ofSize: 32)
        return TV
    }()
    
    let jobDeField: UITextView = {
       let TV = UITextView()
       TV.keyboardAppearance = .dark
       TV.tintColor = UIColor.red
       TV.backgroundColor = UIColor.white
       TV.textColor = .white
       TV.font = .systemFont(ofSize: 32)
       return TV
    }()
    
    let jobTitle: UITextView = {
        let TV = UITextView()
        TV.keyboardAppearance = .dark
        TV.tintColor = UIColor.red
        TV.backgroundColor = UIColor.white
        TV.textColor = .white
        TV.font = .systemFont(ofSize: 32)
        return TV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        
        let editTextBtn = UIButton(frame: CGRect(x: 250.0, y: 10.0, width: 30.0, height: 30.0))
        editTextBtn.setImage(#imageLiteral(resourceName: "Image-13"), for: UIControlState())
        editTextBtn.addTarget(self, action: #selector(showTextField), for: .touchUpInside)
        view.addSubview(editTextBtn)
        
        let sendButton = UIButton(frame: CGRect(x: 300.0, y: 10.0, width: 30.0, height: 30.0))
        sendButton.setImage(#imageLiteral(resourceName: "send_snap"), for: UIControlState())
        sendButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        view.addSubview(sendButton)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        let theFile = SwiftyCamViewController.key.file
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child("posts").child(filename)
        _ = ref.putFile(from: theFile!, metadata: nil) { metadata, error in
            if let error = error{
                print("CJ error: error \(error)")
            } else{
                guard let downloadURL = metadata!.downloadURL()?.absoluteString else { return }
                self.saveToDataBaseWithImageURL(urlString: downloadURL)
            }
        }
    }
    
    fileprivate func saveToDataBaseWithImageURL(urlString: String) {
        guard let jobDescrip = jobDeField.text else { return }
        guard let salaryAmt = salaryField.text else { return }
        guard let benefit = benefitField.text else { return }
        guard let typeDescrip = typeField.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values = ["videoURL": urlString, "Job Description": jobDescrip,"Salary": salaryAmt,"Benefits": benefit,"Type": typeDescrip, "CreationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save post to DB:", err)
                return
            }
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func showTextField() {
        view.addSubview(jobDeField)
        jobDeField.anchor(top: view.centerYAnchor, left: nil, bottom: nil, right: view.centerXAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        view.addSubview(salaryField)
        salaryField.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        view.addSubview(benefitField)
        benefitField.anchor(top: salaryField.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        view.addSubview(typeField)
        typeField.anchor(top: benefitField.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        view.addSubview(jobTitle)
        jobTitle.anchor(top: typeField.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}

