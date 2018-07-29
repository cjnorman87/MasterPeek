//
//  MainTabBarController.swift
//  Peek
//
//  Created by Chris Norman on 4/2/18.
//  Copyright © 2018 Chris Norman. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        setUpSerControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpSerControllers() {
        
        //Search
        let searchNavController = templateNavController(unselected: #imageLiteral(resourceName: "AS"), selectedImage: #imageLiteral(resourceName: "S"), rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //Jobs
        let jobsNavController = templateNavController(unselected: #imageLiteral(resourceName: "AJ"), selectedImage: #imageLiteral(resourceName: "J"), rootViewController: JobsController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //Profile
        let profileNavController = templateNavController(unselected: #imageLiteral(resourceName: "AP"), selectedImage: #imageLiteral(resourceName: "P"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        tabBar.tintColor = UIColor.rgb(red: 103, green: 174, blue: 202)
        tabBar.unselectedItemTintColor = UIColor.darkGray
        
        viewControllers = [searchNavController,
                           jobsNavController,
                           profileNavController]
        //Modify tab bar items
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    func setUpRecControllers() {
        
        //Search
        let searchNavController = templateNavController(unselected: #imageLiteral(resourceName: "AS"), selectedImage: #imageLiteral(resourceName: "S"), rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //Jobs
        let jobsNavController = templateNavController(unselected: #imageLiteral(resourceName: "Post Button"), selectedImage: #imageLiteral(resourceName: "Post Button"), rootViewController: camController())
        
        //Profile
        let profileNavController = templateNavController(unselected: #imageLiteral(resourceName: "AP"), selectedImage: #imageLiteral(resourceName: "P"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        tabBar.tintColor = UIColor.rgb(red: 103, green: 174, blue: 202)
        tabBar.unselectedItemTintColor = UIColor.darkGray
        
        viewControllers = [searchNavController,
                           jobsNavController,
                           profileNavController]
        //Modify tab bar items
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }

    fileprivate func templateNavController(unselected: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
