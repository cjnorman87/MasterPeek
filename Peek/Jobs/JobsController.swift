//
//  JobsController.swift
//  Gazorpian
//
//  Created by Christopher Norman on 10/14/17.
//  Copyright © 2017 yakuza. All rights reserved.
//

import UIKit

class JobsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellid = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        collectionView?.backgroundColor = .white
        collectionView?.register(JobPostCell.self, forCellWithReuseIdentifier: cellid)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        self.navigationController?.navigationBar.sizeToFit()

        setupNavItems()
    }
    
    let jobTypeSegmentedControl: UISegmentedControl = {
        let types = ["Applied", "Liked"]
        
        let sc = UISegmentedControl(items: types)
        sc.isOpaque = true
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.rgb(red: 103, green: 174, blue: 202)
        sc.backgroundColor = .white
        return sc
    }()
    
    fileprivate func setupNavItems() {
        navigationController?.navigationBar.addSubview(jobTypeSegmentedControl)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBar = navigationController?.navigationBar
        jobTypeSegmentedControl.anchor(top: navBar?.bottomAnchor, left: navBar?.leftAnchor, bottom: nil, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        navigationItem.title = "Jobs"
        navigationController?.navigationBar.barTintColor = .white
    }
    
    @objc func handleAddCompany() {
        print("Adding company..")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! JobPostCell
        
        return cell
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        
        //Important!
        if #available(iOS 11.0, *) {
            
            //Default NavigationBar Height is 44. Custom NavigationBar Height is 66. So We should set additionalSafeAreaInsets to 66-44 = 22
            self.additionalSafeAreaInsets.top = 22
            
        }
        
    }
}

class NavigationBar: UINavigationBar {
    
    //set NavigationBar's height
    var customHeight : CGFloat = 200
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: customHeight)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame = CGRect(x: frame.origin.x, y:  0, width: frame.size.width, height: customHeight)
        
        // title position (statusbar height / 2)
        setTitleVerticalPositionAdjustment(-10, for: UIBarMetrics.default)
        
        for subview in self.subviews {
            var stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarBackground") {
                subview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: customHeight)
                subview.backgroundColor = .yellow
                
            }
            
            stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarContent") {
                
                subview.frame = CGRect(x: subview.frame.origin.x, y: 20, width: subview.frame.width, height: customHeight - 20)
                
                subview.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.4)
                
            }
        }
    }
}
