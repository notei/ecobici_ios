//
//  AppUtils.swift
//  Audit
//
//  Created by Alberto Farías on 9/7/18.
//  Copyright © 2018 2 Geeks one Monkey. All rights reserved.
//

import Foundation
import UIKit

class AppUtils{
    
    public static func setupNavBarApp(navigationItem:UINavigationItem,navigationController:UINavigationController ){
        //NAVIGATION BAR ----------------------------------
        let logo = UIImage(named: "app_ico_logo.png")
        let imageView = UIImageView(image:logo)
        navigationItem.titleView = imageView
        
        let backButton = UIBarButtonItem()
        backButton.title = "Atras";
        navigationController.navigationBar.topItem!.backBarButtonItem = backButton
        
        navigationController.navigationBar.barTintColor = UIColor.white
        //NAVIGATION BAR ----------------------------------
    }
    
    
    
}
