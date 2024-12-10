//
//  ContentTabView.swift
//  Cookbook
//
//  Created by Neo on 24/09/2023.
//

import SwiftUI

struct ContentTabView: View {
    @Environment(Navigator.self) private var navigator
    
    var body: some View {
        @Bindable var navState = navigator
        
        TabView(selection: $navState.selectedTab) {
            RecipeNavigationStack()
                .environment(navigator.recipeViewModel)
                .tag(Route.recipes)
                .tabItem {
                    Label("LABEL_RECIPES", systemImage: "list.bullet.clipboard")
                }
            
            PantryNavigationStack()
                .tag(Route.pantry)
                .tabItem {
                    Label("LABEL_PANTRY", systemImage: "carrot")
                }
        }
    }
}

#Preview {
    ContentTabView()
        .environment(Navigator())
        .previewEmptyContainer()
}
