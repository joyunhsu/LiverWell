//
//  AppDelegate.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/1.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // swiftlint:disable identifier_name
    static let db = Firestore.firestore()
    // swiftlint:enable identifier_name

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FIRFirestoreService.shared.configure()

        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in

            guard user != nil else {

                //Login

                let storyboard = UIStoryboard(name: "Auth", bundle: nil)

                self?.window?.rootViewController = storyboard.instantiateInitialViewController()

                return
            }

            //Lobby

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            self?.window?.rootViewController = storyboard.instantiateInitialViewController()
            
            let userDefaults = UserDefaults.standard
            
//            let user = Auth.auth().currentUser
            
            userDefaults.set(user!.uid, forKey: "uid")

        }
        
        IQKeyboardManager.shared.enable = true
        
        Fabric.with([Crashlytics.self])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}
