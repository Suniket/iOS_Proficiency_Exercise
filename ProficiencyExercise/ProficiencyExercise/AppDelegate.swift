//
//  AppDelegate.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 3/12/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var viewModel: MainViewModel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = MainViewController()
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        
        window?.makeKeyAndVisible()
        return true
    }

   

}

