//
//  RecipeViewModel.swift
//  Cookbook
//
//  Created by Neo Salmon on 02/12/2023.
//

import Foundation
import CookbookRecipesKit
import SwiftUI

@Observable
class RecipeViewModel {
    public var navigationState: NavigationPath = .init()
    public var activeRecipe: Recipe?
    
    public var showCreateRecipe: Bool = false
    
    public var searchTerm: String = ""
    
    public func beginMaking(recipe: Recipe) {
        activeRecipe = recipe
    }
    
    func handleQuickAction(_ actionId: String) {
        
    }
}
