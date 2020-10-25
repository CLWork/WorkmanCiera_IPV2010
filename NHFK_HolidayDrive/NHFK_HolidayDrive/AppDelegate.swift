//
//  AppDelegate.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import UIKit
import Firebase
import FBSDKCoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(
           _ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
       ) -> Bool {
             
           ApplicationDelegate.shared.application(
               application,
               didFinishLaunchingWithOptions: launchOptions
           )
        FirebaseApp.configure()

        let _ = Firestore.firestore()
           return true
       }
             
       func application(
           _ app: UIApplication,
           open url: URL,
           options: [UIApplication.OpenURLOptionsKey : Any] = [:]
       ) -> Bool {

           ApplicationDelegate.shared.application(
               app,
               open: url,
               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
               annotation: options[UIApplication.OpenURLOptionsKey.annotation]
           )

       }


}

