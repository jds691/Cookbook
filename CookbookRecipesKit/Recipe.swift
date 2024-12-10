//
//  Recipe.swift
//  CookbookRecipesKit
//
//  Created by Neo Salmon on 02/12/2023.
//

import Foundation
import SwiftData
import UIKit

@Model
public final class Recipe: Identifiable, Sendable {
    @Attribute(.unique)
    public let id: UUID
    
    public var name: String
    public var details: String
    @Attribute(.externalStorage)
    public var previewImage: Data?
    
    @Relationship(deleteRule: .cascade)
    public var items: [RecipeItem]
    
    public init() {
        id = UUID()
        name = "New Recipe"
        details = "My new recipe!"
        
        items = []
    }
    
    public static var preview: Recipe {
        var recipe = Recipe()
        
        recipe.name = "Iced Mango Latte"
        recipe.details = "A delicous iced latte for a hot summers day with a fruity twist!"
        recipe.previewImage = UIImage(named: "MangoIcedLatte")?.pngData()
        
        var item = RecipeItem()
        item.name = "Drink"
        
        item.ingrediants = [
            "Mango Pieces",
            "2 tsp Sugar",
            "40ml Water",
            "60ml Milk"
        ]
        
        recipe.items.append(item)
        
        return recipe
    }
    
    public static var listPreview: [Recipe] {
        [
            .preview
        ]
    }
}

extension Recipe {
    
    //FIXME: Terribly optimised but hey it works?
    @Transient
    public var ingredients: [String] {
        var ingrediants: [String] = []
        
        for item in self.items {
            for ingrediant in item.ingrediants {
                if !ingrediants.contains(ingrediant) {
                    ingrediants.append(ingrediant)
                }
            }
        }
        
        return ingrediants
    }
}
