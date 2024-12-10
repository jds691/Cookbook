//
//  CookbookIntentsExtension.swift
//  CookbookIntents
//
//  Created by Neo on 09/10/2023.
//

import AppIntents
import SwiftData
import CookbookKit
import CookbookRecipesKit

let modelContainer: ModelContainer = {
    let schema = Schema([
        PantryItem.self,
        Recipe.self
    ])
    let fm = FileManager.default
    let modelURL: URL = fm.containerURL(forSecurityApplicationGroupIdentifier: "group.com.neo.Cookbook")!.appending(path: "Data.store")
    
    let modelConfiguration = ModelConfiguration(schema: schema, url: modelURL)
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

@main
struct CookbookIntentsExtension: AppIntentsExtension {

}

struct CookbookAppShortcutsProvider: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: GetExpiredItemsIntent(),
            phrases: [
                "What food has expired in \(.applicationName)"
            ],
            shortTitle: "GetExpiredItemsIntent.shortcut.shortTitle", // Expired
            systemImageName: "xmark"
        )
        AppShortcut(
            intent: GetExpiringSoonItemsIntent(),
            phrases: [
                "What food is expiring in \(.applicationName)",
                "What food is expiring soon in \(.applicationName)",
                "Is any food expiring in \(.applicationName)",
                "Is any food expiring soon in \(.applicationName)"
            ],
            shortTitle: "GetExpiringSoonItemsIntent.shortcut.shortTitle",
            systemImageName: "clock"
        )
    }
}
