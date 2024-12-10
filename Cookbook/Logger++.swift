//
//  Logger++.swift
//  Cookbook
//
//  Created by Neo Salmon on 22/09/2024.
//

import os
import Foundation

extension Logger {
    //MARK: Common
    
    //MARK: Pantry
    static var pantry: Logger = .init(
        subsystem: Bundle.main.bundleIdentifier ?? "App",
        category: "Pantry"
    )
    
    //MARK: Recipes
    static var recipes: Logger = .init(
        subsystem: Bundle.main.bundleIdentifier ?? "App",
        category: "Recipes"
    )
    
    //MARK: System
    static var navigator: Logger = .init(
        subsystem: Bundle.main.bundleIdentifier ?? "App",
        category: "Navigator"
    )
    
    static var app: Logger = .init(
        subsystem: Bundle.main.bundleIdentifier ?? "App",
        category: "App"
    )
    
    static var appDelegate: Logger = .init(
        subsystem: Bundle.main.bundleIdentifier ?? "App",
        category: "App+Scene Delegate"
    )
    
    static var notifications: Logger = .init(
        subsystem: Bundle.main.bundleIdentifier ?? "App",
        category: "UserNotifications"
    )
    
    static var quickActions: Logger = .init(
        subsystem: Bundle.main.bundleIdentifier ?? "App",
        category: "QuickActionManager"
    )
}
