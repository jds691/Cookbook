//
//  Logger++.swift
//  Cookbook
//
//  Created by Neo Salmon on 10/12/2024.
//

import os

extension Logger {
    static var controller: Logger = .init(
        subsystem: "CookbookRecipeKit",
        category: "RecipeController"
    )
}
