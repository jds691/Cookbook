//
//  RecipeItem.swift
//  CookbookRecipesKit
//
//  Created by Neo Salmon on 02/12/2023.
//

import Foundation
import SwiftData

@Model
public final class RecipeItem: Sendable {
    @Relationship(inverse: \Recipe.items)
    public var recipe: Recipe?
    
    public var name: String
    
    public var ingrediants: [String]
    
    @Relationship(deleteRule: .cascade)
    public var steps: [RecipeStep]
    
    public init() {
        name = "Item"
        
        ingrediants = []
        
        steps = []
    }
}
