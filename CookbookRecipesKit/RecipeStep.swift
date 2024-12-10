//
//  RecipeStep.swift
//  CookbookRecipesKit
//
//  Created by Neo Salmon on 02/12/2023.
//

import Foundation
import SwiftData

@Model
public final class RecipeStep: Sendable {
    @Relationship(inverse: \RecipeItem.steps)
    public var item: RecipeItem?
    
    public var name: String
    public var details: String
    
    public init() {
        name = "Next Step"
        details = ""
    }
}
