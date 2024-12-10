//
//  View+ModelContainer.swift
//  Cookbook
//
//  Created by Neo on 25/09/2023.
//

import SwiftUI
import SwiftData
import CookbookKit
import CookbookRecipesKit

extension View {
    func previewEmptyContainer() -> some View {
        self
            .modelContainer(for: [PantryItem.self, Recipe.self], inMemory: true)
    }
    
    @MainActor
    func previewFilledContainer() -> some View {
        do {
            let container = try ModelContainer(for: PantryItem.self, Recipe.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            
            for item in PantryItem.listPreview {
                container.mainContext.insert(item)
            }
            
            for recipe in Recipe.listPreview {
                container.mainContext.insert(recipe)
            }
            
            return self
                .modelContainer(container)
        } catch {
            fatalError("Failed to create preview containers.")
        } 
    }
}
