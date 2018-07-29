//
//  showCamController.swift
//  Gazorpian
//
//  Created by Christopher Norman on 9/18/17.
//  Copyright © 2017 yakuza. All rights reserved.
//

import UIKit

class showCamController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .red
        handleCamera()
    }
    
    func handleCamera() {
        let cameraController = camController()
        present(cameraController, animated: true, completion: nil)
        
    }
}
