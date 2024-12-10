//
//  PantryItemState.swift
//  CookbookKit
//
//  Created by Neo on 24/09/2023.
//

import Foundation

public enum PantryItemState: Codable, Hashable, CaseIterable, Sendable, RawRepresentable {
    case sealed, opened, frozen, expired
    
    public typealias RawValue = Int
    
    // REVIEW: Why have I done this?
    public init?(rawValue: Int) {
        switch rawValue {
            case 0 : self = .sealed
            case 1 : self = .opened
            case 2 : self = .frozen
            case 3 : self = .expired
            default : return nil
        }
    }
    
    public var rawValue: Int {
        switch self {
            case .sealed : return 0
            case .opened :  return 1
            case .frozen : return 2
            case .expired : return 3
        }
    }
}
