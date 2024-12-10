//
//  GetExpiringSoonItemsIntent.swift
//  CookbookIntents
//
//  Created by Neo on 09/10/2023.
//

import AppIntents
import SwiftData
import CookbookKit
import SwiftUI

struct GetExpiringSoonItemsIntent: AppIntent {
    static var title: LocalizedStringResource = "GetExpiringSoonItemsIntent.title"
    
    //@Dependency
    //private var modelContainer: ModelContainer
    
    @MainActor
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        let context = ModelContext(modelContainer)
        
        var expiringSoonItems: [PantryItem] = []
        
        try context.enumerate(FetchDescriptor<PantryItem>()) { item in
            if item.isExpiringSoon {
                expiringSoonItems.append(item)
            }
        }
        
        let itemsExpiringSoonDialogResource: LocalizedStringResource = .init(
            "\(expiringSoonItems.count)_ITEMS_EXPIRING_SOON_DIALOG"
        )
        
        if expiringSoonItems.isEmpty {
            return .result(dialog: IntentDialog(itemsExpiringSoonDialogResource))
        } else {
            return .result(dialog: IntentDialog(itemsExpiringSoonDialogResource), view:
                VStack(alignment: .leading) {
                    ForEach(expiringSoonItems, id: \.id) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.status)
                                .foregroundStyle(.orange)
                            Divider()
                        }
                    }
                }
                .scenePadding()
            )
        }
    }
}

/*
 VStack(alignment: .leading) {
     Text(item.name)
         .font(.headline)
     Text(item.status)
         .foregroundStyle(.orange)
     Divider()
 }
 */
