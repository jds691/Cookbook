//
//  Navigator.swift
//  Cookbook
//
//  Created by Neo Salmon on 02/12/2023.
//

import os
import Foundation
import SwiftUI
import CookbookRecipesKit

enum Route: String, Codable {
    case recipes, pantry
}

@Observable
final class Navigator {
    public var pantryViewModel: PantryViewModel = .init()
    public var recipeViewModel: RecipeViewModel = .init()
    
    private var routeUpdateInProgress: Bool = false
    
    public var selectedRoute: Route? = .pantry {
        didSet {
            if !routeUpdateInProgress {
                routeUpdateInProgress = true
                
                guard let route = selectedRoute else {
                    Logger.navigator.error("Invalid route")
                    routeUpdateInProgress = false
                    return
                }
                
                selectedTab = route
                routeUpdateInProgress = false
            }
        }
    }
    
    public var selectedTab: Route = .pantry {
        didSet {
            if !routeUpdateInProgress {
                routeUpdateInProgress = true
                selectedRoute = selectedTab
                routeUpdateInProgress = false
            }
        }
    }
        
    @MainActor 
    public func showRecipe(id: UUID) {
        selectedRoute = .recipes
        
        if let recipe = RecipeController.shared.getRecipe(with: id) {
            recipeViewModel.navigationState = NavigationPath([recipe])
        } else {
            Logger.navigator.error("Unable to find a recipe with id: \(id.uuidString)")
        }
    }
}
