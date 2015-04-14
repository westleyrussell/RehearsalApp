//
//  NavigationController.swift
//  LoopBuddy
//
//  Created by Bianchi on 4/13/15.
//  Copyright (c) 2015 Westley Russell. All rights reserved.
//

import Foundation


class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    let red = UIColor(red:245/255, green:99/255, blue:86/255, alpha:1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.whiteColor()
    }

}