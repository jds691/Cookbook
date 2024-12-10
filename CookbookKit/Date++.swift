//
//  Date++.swift
//  Cookbook
//
//  Created by Neo on 27/09/2023.
//

import Foundation

let DAY_IN_SECONDS: Double = 86400

public extension Date {
    /// Returns the date with time set to 00:00
    var withoutTime: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    /// Shorthand wrapper for Date.addingTimeInterval
    /// - Parameter days: Number of days to add
    /// - Returns: Date with the number of days added to it
    func addingDays(_ days: Double) -> Date {
        return self.addingTimeInterval(DAY_IN_SECONDS * days)
    }
}
