//
//  CookbookIntents.swift
//  CookbookIntents
//
//  Created by Neo on 09/10/2023.
//

import AppIntents
import SwiftData
import CookbookKit
import SwiftUI

struct GetExpiredItemsIntent: AppIntent {
    static var title: LocalizedStringResource = "GetExpiredItemsIntent.title"
    
    //@Dependency
    //private var modelContainer: ModelContainer
    
    @MainActor
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        let context = ModelContext(modelContainer)
        
        var expiredItems: [PantryItem] = []
        
        try context.enumerate(FetchDescriptor<PantryItem>()) { item in
            if item.state == .expired {
                expiredItems.append(item)
            }
        }

        let expiredItemsDialogResource: LocalizedStringResource = .init(
            "\(expiredItems.count)_EXPIRED_ITEMS_DIALOG"
        )
                
        if expiredItems.isEmpty {
            return .result(dialog: IntentDialog(expiredItemsDialogResource))
        } else {
            return .result(dialog: IntentDialog(expiredItemsDialogResource), view:
                VStack(alignment: .leading) {
                    ForEach(expiredItems, id: \.id) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.status)
                                .foregroundStyle(.red)
                            Divider()
                        }
                    }
                }
                .scenePadding()
            )
        }
        
    }
}
