//
//  PantryItem++.swift
//  CookbookIntents
//
//  Created by Neo on 10/10/2023.
//

import CookbookKit

extension PantryItem {
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
