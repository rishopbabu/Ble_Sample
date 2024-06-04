//
//  AppDelegate.swift
//  Ble_Sample
//
//  Created by Rishop Babu on 02/06/24.
//

import UIKit

/// The application's delegate.
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// This method is called after the application has launched and is used for initial setup.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - launchOptions: A dictionary indicating the reason the app was launched (if any).
    /// - Returns: A boolean value indicating whether the app successfully handled the launch request.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    /// This method is called when a new scene session is being created.
    /// Use this method to select a configuration to create the new scene with.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - connectingSceneSession: The session being created.
    ///   - options: Additional options for configuring the scene connection.
    /// - Returns: A configuration object that specifies the configuration for the new scene.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    /// This method is called when the user discards a scene session.
    /// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    /// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - sceneSessions: The set of discarded scene sessions.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

