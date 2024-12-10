//
//  RecipeQuery.swift
//  CookbookIntents
//
//  Created by Neo Salmon on 07/12/2023.
//

import AppIntents
import SwiftData
import CookbookRecipesKit

struct RecipeQuery: EntityStringQuery {
    
    typealias Result = [Entity]
    typealias Entity = RecipeEntity
    
    init() {
        
    }
    
    @Dependency
    private var modelContainer: ModelContainer
    
    @MainActor
    func entities(matching string: String) async throws -> [Entity] {
        let context = ModelContext(modelContainer)
        
        let itemPredicate = #Predicate<Recipe> { item in
            item.name.localizedLowercase.contains(string)
        }
        
        let itemFetchDescriptor = FetchDescriptor(predicate: itemPredicate)
        
        let items: [Recipe] = try context.fetch(itemFetchDescriptor)
        
        return items.compactMap({ RecipeEntity($0) })
    }
    
    @MainActor
    func entities(for identifiers: [Entity.ID]) async throws -> [Entity] {
        let context = ModelContext(modelContainer)
        
        let itemPredicate = #Predicate<Recipe> { item in
            identifiers.contains(item.id)
        }
        
        let itemFetchDescriptor = FetchDescriptor(predicate: itemPredicate)
        
        let items: [Recipe] = try context.fetch(itemFetchDescriptor)
        
        return items.compactMap({ RecipeEntity($0) })
    }
    
    @MainActor
    func suggestedEntities() async throws -> [Entity] {
        let context = ModelContext(modelContainer)
        
        let itemPredicate = #Predicate<Recipe> { item in
            true //All items will match
        }
        
        let itemFetchDescriptor = FetchDescriptor(predicate: itemPredicate)
        
        let items: [Recipe] = try context.fetch(itemFetchDescriptor)
        
        return items.compactMap({ RecipeEntity($0) })
    }
}
