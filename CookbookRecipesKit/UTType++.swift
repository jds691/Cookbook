//
//  UTType++.swift
//  CookbookRecipesKit
//
//  Created by Neo Salmon on 02/12/2023.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    public static var recipe: UTType {
        .init(exportedAs: "com.neo.Cookbook.recipe")
    }
}
