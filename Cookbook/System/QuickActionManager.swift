//
//  QuickActionManager.swift
//  Cookbook
//
//  Created by Neo Salmon on 21/09/2024.
//

import Foundation

class QuickActionManager {
    public var pendingQuickActionIdentifier: String?
    
    public static var instance: QuickActionManager = .init()
    
    private init() {
        
    }
}
