//
//  Logger++.swift
//  Cookbook
//
//  Created by Neo Salmon on 10/12/2024.
//

import os

extension Logger {
    //MARK: Pantry
    static var pantry: Logger = .init(
        subsystem: "CookbookKit",
        category: "Pantry"
    )
    
    //MARK: System
    static var userNotifications: Logger = .init(
        subsystem: "CookbookKit",
        category: "UserNotifications"
    )
}
