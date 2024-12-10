//
//  ContentSidebarView.swift
//  Cookbook
//
//  Created by Neo Salmon on 03/12/2023.
//

import SwiftUI

struct ContentSidebarView: View {
    @Environment(Navigator.self) private var navigator
    
    var body: some View {
        @Bindable var navState = navigator
        
        NavigationSplitView {
            List(selection: $navState.selectedRoute) {
                NavigationLink(value: Route.recipes) {
                    Label("LABEL_RECIPES", systemImage: "list.bullet.clipboard")
                }
                
                NavigationLink(value: Route.pantry) {
                    Label("LABEL_PANTRY", systemImage: "carrot")
                }
            }
        } detail: {
            switch (navigator.selectedRoute) {
                case .pantry:
                    PantryNavigationStack()
                case .recipes:
                    RecipeNavigationStack()
                        .environment(navigator.recipeViewModel)
                case .none:
                    EmptyView()
            }
        }
    }
}

#Preview {
    ContentSidebarView()
        .environment(Navigator())
        .previewEmptyContainer()
}
