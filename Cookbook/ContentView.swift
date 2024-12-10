//
//  ContentView.swift
//  Cookbook
//
//  Created by Neo on 24/09/2023.
//

import SwiftUI
import SwiftData
import CoreSpotlight

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Environment(Navigator.self) private var navigator

    var body: some View {
        //ContentTabView()
        PantryNavigationStack()
            .environment(navigator.pantryViewModel)
    }
}

#Preview {
    ContentView()
        .previewEmptyContainer()
}
