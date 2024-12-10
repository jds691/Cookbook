//
//  PantryItemQuery.swift
//  CookbookIntents
//
//  Created by Neo on 10/10/2023.
//

import AppIntents
import SwiftData
import CookbookKit

struct PantryItemQuery: EntityStringQuery {
    
    typealias Result = [Entity]
    typealias Entity = PantryItemEntity
    
    init() {
        
    }
    
    //@Dependency
    //private var modelContainer: ModelContainer
    
    @MainActor
    func entities(matching string: String) async throws -> [Entity] {
        let context = ModelContext(modelContainer)
        
        let itemPredicate = #Predicate<PantryItem> { item in
            item.name.localizedLowercase.contains(string)
        }
        
        let itemFetchDescriptor = FetchDescriptor(predicate: itemPredicate)
        
        let items: [PantryItem] = try context.fetch(itemFetchDescriptor)
        
        return items.compactMap({ PantryItemEntity($0) })
    }
    
    @MainActor
    func entities(for identifiers: [Entity.ID]) async throws -> [Entity] {
        let context = ModelContext(modelContainer)
        
        let itemPredicate = #Predicate<PantryItem> { item in
            identifiers.contains(item.id)
        }
        
        let itemFetchDescriptor = FetchDescriptor(predicate: itemPredicate)
        
        let items: [PantryItem] = try context.fetch(itemFetchDescriptor)
        
        return items.compactMap({ PantryItemEntity($0) })
    }
    
    @MainActor
    func suggestedEntities() async throws -> [Entity] {
        let context = ModelContext(modelContainer)
        
        let itemPredicate = #Predicate<PantryItem> { item in
            true //All items will match
        }
        
        let itemFetchDescriptor = FetchDescriptor(predicate: itemPredicate)
        
        let items: [PantryItem] = try context.fetch(itemFetchDescriptor)
        
        return items.compactMap({ PantryItemEntity($0) })
    }
    
    /*func results() async throws -> Result {
        <#code#>
    }
    
    func defaultResult() async -> DefaultValue? {
        <#code#>
    }*/
}

/*
 
 typealias Entity = PantryItemEntity
 

 */
