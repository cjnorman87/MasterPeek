//
//  HomeViewController.swift
//  Gazorpian
//
//  Created by Christopher Norman on 9/24/17.
//  Copyright © 2017 yakuza. All rights reserved.
//

import UIKit
import Firebase
import Photos

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let cellid = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellid)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
