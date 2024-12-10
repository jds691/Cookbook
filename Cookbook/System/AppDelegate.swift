//
//  AppDelegate.swift
//  Cookbook
//
//  Created by Neo Salmon on 13/09/2024.
//

import UIKit

// I have Deja-vu from this, which means this isn't the first time I've had issues with this

class AppDelegate: NSObject, UIApplicationDelegate {
    // When the application is launching for the first time
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            QuickActionManager.instance.pendingQuickActionIdentifier = shortcutItem.type
        }
        
        let sceneConfiguration: UISceneConfiguration = .init(name: "Standard", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // When the application has already been constructed
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem) async -> Bool {
        QuickActionManager.instance.pendingQuickActionIdentifier = shortcutItem.type
        
        return true
    }
}
