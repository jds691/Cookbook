//
//  PantryItemEntity.swift
//  CookbookIntents
//
//  Created by Neo on 10/10/2023.
//

import AppIntents

import CookbookKit

struct PantryItemEntity: AppEntity, Identifiable {
    public let id: UUID
    public var name: String
    public var expiryDate: Date
    public var state: PantryItemState
    /// Represent's how long the item has been in it's current state.
    public var inStateSince: Date
    
    public var isExpiringSoon: Bool {
        return state != .frozen && state != .expired && expiryDate <= .now.withoutTime.addingDays(2)
    }
    
    public init(_ model: PantryItem) {
        self.id = model.id
        self.name = model.name
        self.expiryDate = model.expiryDate
        self.state = model.state.entityEnum
        self.inStateSince = model.inStateSince
    }
    
    //MARK: AppEntity
    public static var defaultQuery = PantryItemQuery()
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "PantryItemEntity.typeDisplayRepresentation" // Pantry Item
    
    public var displayRepresentation: DisplayRepresentation {
        .init(title: .init(stringLiteral: self.name), subtitle: .init(stringLiteral: self.status))
    }
    
    var status: String {
        let relativeFormatter = {
            let formatter = RelativeDateTimeFormatter()
            formatter.dateTimeStyle = .named
            
            return formatter
        }()
        
        switch state {
        case .sealed, .opened:
            let relativeText: String = relativeFormatter.localizedString(for: expiryDate, relativeTo: .now.withoutTime)
            
            return "Expires \(relativeText)."
            
            
        case .frozen:
            let relativeText: String = relativeFormatter.localizedString(for: inStateSince.withoutTime, relativeTo: .now.withoutTime)
            
            return "Frozen \(relativeText)."
            
        case .expired:
            let relativeText: String = relativeFormatter.localizedString(for: expiryDate.withoutTime, relativeTo: .now)
            
            return "Expired \(relativeText)."
        }
    }
}

public enum PantryItemState: Int, Codable, Hashable, CaseIterable, Sendable, AppEnum {
    case sealed, opened, frozen, expired
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "PantryItemState.typeDisplayRepresentation"
    
    public static var caseDisplayRepresentations: [PantryItemState : DisplayRepresentation] = [
        .sealed : .init(title: "ITEM_STATE_SEALED", image: .init(systemName: "shippingbox")),
        .opened : .init(title: "ITEM_STATE_OPENED", image: .init(systemName: "clock")),
        .frozen : .init(title: "ITEM_STATE_FROZEN", image: .init(systemName: "snowflake")),
        .expired : .init(title: "ITEM_STATE_EXPIRED", image: .init(systemName: "xmark"))
    ]
}

extension CookbookKit.PantryItemState {
    public var entityEnum: CookbookIntents.PantryItemState {
        switch self {
        case .sealed:
                .sealed
        case .opened:
                .opened
        case .frozen:
                .frozen
        case .expired:
                .expired
        }
    }
}
