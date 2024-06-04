//
//  SceneDelegate.swift
//  Ble_Sample
//
//  Created by Rishop Babu on 02/06/24.
//

import UIKit

/// The Scene delegate.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    /// This method is called when a scene is being added to the app.
    /// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    /// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    /// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    /// - Parameters:
    ///   - scene: The scene being connected to the app.
    ///   - session: The session associated with the scene.
    ///   - connectionOptions: Additional options for configuring the connection of the scene.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: ViewController())
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    /// This method is called as the scene is being released by the system.
    /// This occurs shortly after the scene enters the background, or when its session is discarded.
    /// Release any resources associated with this scene that can be re-created the next time the scene connects.
    /// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    /// - Parameter scene: The scene being disconnected.
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    /// This method is called when the scene has moved from an inactive state to an active state.
    /// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    /// - Parameter scene: The scene that has become active.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    /// This method is called when the scene will move from an active state to an inactive state.
    /// This may occur due to temporary interruptions (e.g., an incoming phone call).
    /// - Parameter scene: The scene that will resign active.
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    /// This method is called as the scene transitions from the background to the foreground.
    /// Use this method to undo the changes made on entering the background.
    /// - Parameter scene: The scene that is entering the foreground.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    /// This method is called as the scene transitions from the foreground to the background.
    /// Use this method to save data, release shared resources, and store enough scene-specific state information
    /// to restore the scene back to its current state.
    /// - Parameter scene: The scene that is entering the background.
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

