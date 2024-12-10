//
//  PantryViewModel.swift
//  Cookbook
//
//  Created by Neo Salmon on 20/09/2024.
//

import os
import Foundation
import SwiftUI

@Observable
class PantryViewModel {
    public var showAddSheet: Bool = false
    public var searchTerm: String = ""
    
    func handleQuickAction(_ actionId: String) {
        Logger.pantry.debug("Handling quick action for 'pantry'")
        let action: String = actionId.replacingOccurrences(of: "pantry.", with: "")
        
        switch action {
            case "add-item":
                showAddSheet = true
            default:
                Logger.pantry.error("Unknown quick action '\(action) for view ID 'pantry'")
        }
    }
}
