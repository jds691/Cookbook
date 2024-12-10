//
//  RecipeController.swift
//  CookbookRecipesKit
//
//  Created by Neo Salmon on 02/12/2023.
//

import os
import Foundation
import CoreSpotlight
import SwiftUI
import SwiftData

@MainActor
public class RecipeController {
    
    private var modelContainer: ModelContainer?
    
    private init() {
        
    }
    
    public static let shared = RecipeController()
    
    public func setModelContainer(_ container: ModelContainer) {
        self.modelContainer = container
    }
    
    public func getRecipe(with id: UUID) -> Recipe? {
        guard let container = modelContainer else {
            return nil
        }
        
        let predicate = #Predicate<Recipe> { recipe in
            recipe.id == id
        }
        let fetchDescriptor = FetchDescriptor<Recipe>(predicate: predicate)
        
        do {
            let results = try container.mainContext.fetch(fetchDescriptor)
            
            if results.count > 0 {
                return results.first!
            }
            
        } catch {
            
        }
        
        return nil
    }
}

//MARK: CoreSpotlight
extension RecipeController {
    private static let kDomainIdentifier = "recipe"
    
    private enum CoreSpotlightAction: String {
        case makeRecipe = "recipe.make"
    }
    
    /// Indexes the users recipes into CoreSpotlight.
    private func createSearchableItem(for recipe: Recipe) -> CSSearchableItem {
        let attributeSet = CSSearchableItemAttributeSet(contentType: .recipe)
        attributeSet.displayName = recipe.name
        attributeSet.contentDescription = recipe.details
        attributeSet.thumbnailData = recipe.previewImage
        attributeSet.actionIdentifiers = [
            CoreSpotlightAction.makeRecipe.rawValue
        ]
        
        return CSSearchableItem(uniqueIdentifier: "recipe.\(recipe.id.uuidString)", domainIdentifier: Self.kDomainIdentifier, attributeSet: attributeSet)
    }
    
    public func indexRecipe(_ recipe: Recipe) {
        guard CSSearchableIndex.isIndexingAvailable() else {
            return
        }
        
        let item = createSearchableItem(for: recipe)
        
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error {
                Logger.controller.error("\(error.localizedDescription)")
            }
        }
        
        Logger.controller.debug("Indexed recipe \(recipe.id.uuidString)")
    }
    
    public func indexAllRecipes() {
        if !CSSearchableIndex.isIndexingAvailable() {
            return
        }
        
        guard let container = modelContainer else {
            return
        }
        
        do {
            var indexItems: [CSSearchableItem] = []
            
            try container.mainContext.enumerate(FetchDescriptor<Recipe>()) { recipe in
                let item = createSearchableItem(for: recipe)
                
                indexItems.append(item)
            }
            
            let item = createSearchableItem(for: .preview)
            
            indexItems.append(item)
            
            CSSearchableIndex.default().indexSearchableItems(indexItems) { error in
                if let error {
                    Logger.controller.error("\(error.localizedDescription)")
                }
            }
            Logger.controller.debug("Indexing completed")
        } catch {
            Logger.controller.error("Indexing error: \(error.localizedDescription)")
        }
    }
}
