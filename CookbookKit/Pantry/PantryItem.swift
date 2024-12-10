//
//  PantryItem.swift
//  CookbookKit
//
//  Created by Neo on 24/09/2023.
//

import Foundation
import SwiftData

@Model
public final class PantryItem: Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public var expiryDate: Date
    public var state: PantryItemState
    /// Represent's how long it takes for an item to expire once it has been opened.
    public var expiresAfter: Int?
    /// Represent's how long the item has been in it's current state.
    public var inStateSince: Date
    
    public var isExpiringSoon: Bool {
        return state != .frozen && state != .expired && expiryDate <= .now.withoutTime.addingDays(2)
    }
    
    public init() {
        self.id = UUID()
        self.name = "Item"
        self.expiryDate = .now
        self.state = .sealed
        self.expiresAfter = nil
        self.inStateSince = .now
    }
    
    public func freeze() {
        state = .frozen
        inStateSince = .now
        
        Task {
            await self.scheduleAllNotifications(refresh: true)
        }
    }
    
    public func open() {
        if let expiresAfter {
            if state == .frozen {
                // Assume it's safe to eat for 2 day
                expiryDate = .now.withoutTime.addingDays(2)
            } else if state == .sealed {
                expiryDate = .now.withoutTime.addingDays(2 + Double(expiresAfter))
            }
        }
        
        state = .opened
        inStateSince = .now
        
        Task {
            await self.scheduleAllNotifications(refresh: true)
        }
    }
    
    public func seal() {
        state = .sealed
        inStateSince = .now
        
        Task {
            await self.scheduleAllNotifications(refresh: true)
        }
    }
}

//MARK: Previews
public extension PantryItem {
    static var sealedPreview: PantryItem {
        let item = PantryItem()
        
        item.name = "Eggs"
        // 1 Week
        item.expiryDate = .now.addingDays(7)
        
        return item
    }
    
    static var openedPreview: PantryItem {
        let item = PantryItem()
        
        item.name = "Eggs"
        item.state = .opened
        // 1 Week
        item.expiryDate = .now.addingDays(7)
        
        return item
    }
    
    static var frozenPreview: PantryItem {
        let item = PantryItem()
        
        item.name = "Eggs"
        item.state = .frozen
        // 1 Week ago
        item.inStateSince = .now.addingDays(-7)
        // 1 Week
        item.expiryDate = .now.addingDays(7)
        
        return item
    }
    
    static var expiredPreview: PantryItem {
        let item = PantryItem()
        
        item.name = "Eggs"
        item.state = .expired
        // 1 Week ago
        //item.inStateSince = .now.addingTimeInterval(TimeInterval(-604800))
        item.inStateSince = .now
        // 1 Week
        //item.expiryDate = .now.addingTimeInterval(TimeInterval(-604800))
        item.expiryDate = .now
        
        return item
    }
    
    static var listPreview: [PantryItem] {
        var items: [PantryItem] = []
                
        let eggs = PantryItem()
        let bacon = PantryItem()
        let cheese = PantryItem()
        let milk = PantryItem()
        let noodles = PantryItem()
        let pastaBake = PantryItem()
        
        eggs.name = "Eggs"
        bacon.name = "Bacon"
        cheese.name = "Cheese"
        milk.name = "Milk"
        noodles.name = "Soba Noodles"
        pastaBake.name = "Pasta Bake"
        
        eggs.expiryDate = .now.withoutTime.addingDays(366)
        
        bacon.expiryDate = .now.withoutTime.addingDays(7)
        
        cheese.state = .opened
        cheese.expiryDate = .now.withoutTime.addingDays(1)
        
        milk.state = .expired
        // 3 days ago
        milk.inStateSince = .now.withoutTime.addingDays(-3)
        
        noodles.expiryDate = .now.withoutTime.addingDays(31)
        
        pastaBake.state = .frozen
        pastaBake.inStateSince = .now.withoutTime.addingDays(-7)
        
        items.append(eggs)
        items.append(bacon)
        items.append(cheese)
        items.append(milk)
        items.append(noodles)
        items.append(pastaBake)
        
        return items
    }
}
