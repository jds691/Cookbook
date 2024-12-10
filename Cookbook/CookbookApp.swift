//
//  CookbookApp.swift
//  Cookbook
//
//  Created by Neo on 24/09/2023.
//

import os
import SwiftUI
import SwiftData
import CookbookKit
import CookbookRecipesKit
import UserNotifications
import CoreSpotlight
import AppIntents
import UIKit

fileprivate let modelContainer: ModelContainer = {
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
struct CookbookApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var navigator: Navigator = .init()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(navigator)
                .onContinueUserActivity(CSSearchableItemActionType, perform: { userActivity in
                    
                    guard let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
                        Logger.app.error("Unable to obtain activity identifier")
                        return
                    }
                    
                    if uniqueIdentifier.starts(with: "recipe") {
                        let id = uniqueIdentifier.replacing("recipe.", with: "")
                        navigator.showRecipe(id: UUID(uuidString: id) ?? UUID())
                    } else {
                        Logger.app.error("Unknown CoreSpotlight item: \(uniqueIdentifier)")
                    }
                })
                .task {
                    RecipeController.shared.setModelContainer(modelContainer)
                    RecipeController.shared.indexAllRecipes()
                    
                    do {
                        try await UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert])
                                                
                        try modelContainer.mainContext.enumerate(FetchDescriptor<PantryItem>()) { item in
                            Task {
                                await item.scheduleAllNotifications(refresh: true)
                                Logger.app.debug("Updated record \(item.id.uuidString)")
                            }
                        }
                    } catch {
                        
                    }
                }
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    Logger.app.debug("Scene phase changed, current phase: \(String(describing: newPhase))")
                    Logger.app.debug("Pending quick action identifier: \(String(describing: QuickActionManager.instance.pendingQuickActionIdentifier))")
                    
                    if newPhase == .active, let actionIdentifier = QuickActionManager.instance.pendingQuickActionIdentifier {
                        
                        handleQuickAction(actionIdentifier)
                        
                        // We don't care if it's handled or not
                        QuickActionManager.instance.pendingQuickActionIdentifier = nil
                    }
                }
        }
        .modelContainer(modelContainer)
    }
    
    private func handleQuickAction(_ actionType: String) {
        let actionComponents = actionType.split(separator: ".")
        
        switch actionComponents[0] {
            case "pantry":
                navigator.pantryViewModel.handleQuickAction(actionType)
            default:
                Logger.app.error("Unknown view ID: '\(actionComponents[0])'")
        }
    }
}
