//
//  GetPantryItemDetailsIntent.swift
//  CookbookIntents
//
//  Created by Neo on 10/10/2023.
//

import AppIntents
import SwiftUI
import CookbookKit

struct GetPantryItemExpiryIntent: AppIntent {
    static var title: LocalizedStringResource = "GetPantryItemExpiryIntent.title"
    
    @Parameter(
        title: "GetPantryItemExpiryIntent.pantryItem.title",
        requestValueDialog: "GetPantryItemExpiryIntent.pantryItem.requestValueDialog"
    )
    var pantryItem: PantryItemEntity
    
    var dialog: IntentDialog {
        let alreadyExpiredDialog: LocalizedStringResource = .init(
            "GetPantryItemExpiryIntent.\(pantryItem.name).state.expired"
        )
        
        let notExpiredDialog: LocalizedStringResource = .init(
            "GetPantryItemExpiryIntent.\(pantryItem.name).state.other.on.\(pantryItem.expiryDate.formatted())"
        )
        
        return switch pantryItem.state {
            case .sealed, .opened, .frozen:
                IntentDialog(notExpiredDialog)
            case .expired:
                IntentDialog(alreadyExpiredDialog)
        }
    }
    
    func perform() async throws -> some ProvidesDialog {
        return .result(dialog: self.dialog)
    }
}
