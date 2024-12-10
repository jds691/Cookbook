//
//  PantryItem+UserNotifications.swift
//  CookbookKit
//
//  Created by Neo on 05/10/2023.
//

import os
import UserNotifications

public extension PantryItem {
    
    private var notificationIdentifierPrefix: String {
        "cookbook.pantry.item.\(self.id.uuidString)"
    }
    
    /// Schedules all relevant notifications for the item's current state.
    /// - Parameter refresh: Indicates if the class should remove all currently scheduled notifications and remake them.
    func scheduleAllNotifications(refresh: Bool = false) async {
        if refresh {
            Logger.userNotifications.debug("Notification refresh for \(self.id.uuidString) requested, removing current notifications")
            removeAllNotifications()
        }
        
        if state == .expired || state == .frozen {
            Logger.userNotifications.info("Item \(self.id.uuidString) state is \(String(describing: self.state)), no notifications can be scheduled")
            // There are no relevant notifications to schedule
            return
        }
                
        let calendar: Calendar = Calendar.current
        
        let almostExpiredNotificationContent = UNMutableNotificationContent()
        let expiredNotificationContent = UNMutableNotificationContent()
        
        almostExpiredNotificationContent.title = almostExpiredTitle
        almostExpiredNotificationContent.body = almostExpiredContent
        
        expiredNotificationContent.title = expiredTitle
        expiredNotificationContent.body = expiredContent
        
        let almostExpiredTrigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: expiryDate.withoutTime.addingDays(-2)), repeats: false)
        let expiredTrigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: expiryDate.withoutTime), repeats: false)
        
        let almostExpiredRequest = UNNotificationRequest(identifier: "\(notificationIdentifierPrefix).\(PantryItemState.opened.rawValue)", content: almostExpiredNotificationContent, trigger: almostExpiredTrigger)
        let expiredRequest = UNNotificationRequest(identifier: "\(notificationIdentifierPrefix).\(PantryItemState.expired.rawValue)", content: expiredNotificationContent, trigger: expiredTrigger)
        
        do {
            try await UNUserNotificationCenter.current().add(almostExpiredRequest)
            try await UNUserNotificationCenter.current().add(expiredRequest)
        } catch {
            
        }
    }
    
    func removeAllNotifications() {
        var notificationIdentifiers: [String] = []
        
        for state in PantryItemState.allCases {
            notificationIdentifiers.append("\(notificationIdentifierPrefix).\(state.rawValue)")
        }

        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification: UNNotificationRequest in notificationRequests {
                if notificationIdentifiers.contains(notification.identifier) {
                    identifiers.append(notification.identifier)
                }
            }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    //MARK: Localization
    fileprivate var almostExpiredTitle: String {
        var resource: LocalizedStringResource =
            .init(
                "NOTIFICATION_ITEM_ALMOST_EXPIRED_TITLE",
                defaultValue: "\(self.name) expires soon"
            )
        
        resource.locale = .current
        
        return .init(localized: resource)
    }
    
    fileprivate var almostExpiredContent: String {
        var resource: LocalizedStringResource =
            .init(
                "NOTIFICATION_ITEM_ALMOST_EXPIRED_CONTENT",
                defaultValue: "\(self.name) needs to be eaten within 2 days."
            )
        
        resource.locale = .current
        
        return .init(localized: resource)
    }
    
    fileprivate var expiredTitle: String {
        var resource: LocalizedStringResource =
            .init(
                "NOTIFICATION_ITEM_EXPIRED_TITLE",
                defaultValue: "\(self.name) has expired"
            )
        
        resource.locale = .current
        
        return .init(localized: resource)
    }
    
    fileprivate var expiredContent: String {
        var resource: LocalizedStringResource =
            .init(
                "NOTIFICATION_ITEM_EXPIRED_CONTENT",
                defaultValue: "It may be unsafe to eat."
            )
        
        resource.locale = .current
        
        return .init(localized: resource)
    }
}
