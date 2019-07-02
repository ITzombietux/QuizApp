//
//  AppDelegate.swift
//  QuizApp
//
//  Created by zombietux on 28/06/2019.
//  Copyright © 2019 zombietux. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = QuestionViewController(question: "A Question?", options: ["Option1", "Option2"]) {
            print($0)
        }
        _ = viewController.view
        viewController.tableView.allowsMultipleSelection = true
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }
}

