//
//  PantryEditItemView.swift
//  Cookbook
//
//  Created by Neo on 24/09/2023.
//

import os
import SwiftUI
import CookbookKit

struct PantryEditItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
        
    private var existingItem: PantryItem?
    @State private var itemName: String = ""
    @State private var itemExpiry: Date = .now.addingDays(1)// Tomorrow
    @State private var itemState: PantryItemState = .sealed
    @State private var itemExpiresAfter: Int = 2
    @State private var itemStateSetTime: Date = .now
    
    /// Creates a brand new item that is saved to the modelContext.
    public init() {
        
    }
    
    /// Edits an existing item and updates it within the modelContext.
    public init(item: PantryItem) {
        self.existingItem = item
        
        _itemName = State(initialValue: item.name)
        _itemExpiry = State(initialValue: item.expiryDate.addingDays(-1))
        _itemState = State(initialValue: item.state)
        _itemExpiresAfter = State(initialValue: item.expiresAfter ?? 2)
        _itemStateSetTime = State(initialValue: item.inStateSince)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("LABEL_NAME", text: $itemName)
                DatePicker("LABEL_EXPIRES", selection: $itemExpiry, displayedComponents: [.date])
                
                Section("LABEL_DETAILS") {
                    Picker("LABEL_STATE", selection: $itemState) {
                        Label("LABEL_STATE_SEALED", systemImage: "shippingbox")
                            .tag(PantryItemState.sealed)
                        Label("LABEL_STATE_OPENED", systemImage: "clock")
                            .tag(PantryItemState.opened)
                        Label("LABEL_STATE_FROZEN", systemImage: "snowflake")
                            .tag(PantryItemState.frozen)
                        if existingItem != nil {
                            Label("LABEL_STATE_EXPIRED", systemImage: "xmark")
                                .tag(PantryItemState.expired)
                        }
                    }
                    
                    switch itemState {
                    case .sealed:
                            Stepper(value: $itemExpiresAfter) {
                                Text(labelExpiresIn)
                            }
                    case .opened:
                        EmptyView()
                    case .frozen:
                        DatePicker(labelFrozenOn, selection: $itemStateSetTime, displayedComponents: [.date])
                    case .expired:
                        EmptyView()
                    }
                }
            }
            .navigationTitle(Text(existingItem != nil ? labelUpdateItem: labelAddToPantry))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("ACTION_CANCEL") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(existingItem != nil ? "ACTION_SAVE" : "ACTION_ADD") {
                        dismiss()
                        Task {
                            await commitPantryItem()
                        }
                    }
                }
            }
        }
    }
    
    // We are mantually adding a day so the notification is received on midnight the day AFTER it expries.
    // Otherwise it is a day early
    private func commitPantryItem() async {
        if let existingItem {
            existingItem.name = itemName
            existingItem.expiryDate = itemExpiry.addingDays(1)
            existingItem.state = itemState
            existingItem.expiresAfter = itemExpiresAfter
            existingItem.inStateSince = itemStateSetTime
            
            await existingItem.scheduleAllNotifications(refresh: true)
            
            do {
                try modelContext.save()
            } catch {
                Logger.pantry.error("modelContext manual save failed")
            }
           
        } else {
            let item = PantryItem()
            item.name = itemName
            item.expiryDate = itemExpiry.addingDays(1).withoutTime
            item.state = itemState
            item.inStateSince = itemStateSetTime
            
            if itemExpiresAfter >= 1 {
                item.expiresAfter = itemExpiresAfter
            }
            
            await item.scheduleAllNotifications()
            
            modelContext.insert(item)
        }
    }
}

//MARK: Localization
extension PantryEditItemView {
    var labelExpiresIn: LocalizedStringResource {
        .init("LABEL_EXPIRES_IN_\(itemExpiresAfter)", table: "Pantry")
    }
    
    var labelFrozenOn: String {
        .init(
            localized: "LABEL_FROZEN_ON",
            defaultValue: "Frozen on",
            table: "Pantry",
            comment: "Date is displayed by the view itself, not the label."
        )
    }
    
    var labelExpires: LocalizedStringResource {
        .init("LABEL_EXPIRES", table: "Pantry")
    }
    
    var labelAddToPantry: LocalizedStringResource {
        .init("LABEL_ADD_TO_PANTRY", table: "Pantry")
    }
    
    var labelUpdateItem: LocalizedStringResource {
        .init("LABEL_UPDATE_ITEM", table: "Pantry")
    }
}

#Preview {
    PantryEditItemView()
        .previewEmptyContainer()
}
