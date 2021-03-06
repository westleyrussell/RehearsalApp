//
//  AppDelegate.swift
//  LoopBuddy
//
//  Created by Westley Russell on 3/23/15.
//  Copyright (c) 2015 Westley Russell. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let red = UIColor(red:245/255, green:99/255, blue:86/255, alpha:1.0)
    var songTitle = "Select a Song"
    var songArtist = "No Song Selected"
    var songAlbum = "No Song Selected"
    var songUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sweet Dreams", ofType: "mp3")!)
    var songStart = 0.0
    var songEnd = 1.0
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = red
        navigationBarAppearace.barTintColor = red
        songTitle = "Select a Song"
        songArtist = "No Song Selected"
        songAlbum = "No Song Selected"
        songUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sweet Dreams", ofType: "mp3")!)
        songStart = 0.0
        songEnd = 1.0
        Util.copyFile("Samples.sqlite")
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

