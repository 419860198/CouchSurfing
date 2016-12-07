//
//  TopTabBarController.swift
//  CouchSurfing
//
//  Created by BG on 12/7/16.
//  Copyright © 2016 monstar. All rights reserved.
//

import UIKit

class TopTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpTabBar()
    }
    
    func setUpTabBar() {
        let homeItem = UITabBarItem(title: "", image: UIImage(), selectedImage: UIImage())//30
        let homeC = NavigationController(rootViewController: HomeViewController())
        homeC.tabBarItem = homeItem
        let newsItem = UITabBarItem(title: nil, image: UIImage(), selectedImage: UIImage())
        let newsC = NavigationController(rootViewController: NewsViewController())
        newsC.tabBarItem = newsItem
        let personalItem = UITabBarItem(title: nil, image: UIImage(), selectedImage: UIImage())
        let personalC = NavigationController(rootViewController: PersonalViewController())
        personalC.tabBarItem = personalItem
        
        self.viewControllers = [homeC,newsC,personalC]
        selectedIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
