//
//  PantryNavigationStack.swift
//  Cookbook
//
//  Created by Neo on 24/09/2023.
//

import SwiftUI
import SwiftData
import CookbookKit

struct PantryNavigationStack: View {
    @Environment(PantryViewModel.self) var viewModel: PantryViewModel
    
    //TODO: Sorting by state crashes the app on launch
    @Query(sort: [SortDescriptor(\PantryItem.expiryDate)]) private var items: [PantryItem]
    var filteredItems: [PantryItem] {
        guard !viewModel.searchTerm.isEmpty else { return items }
        return items.filter { item in
            item.name.lowercased().contains(viewModel.searchTerm.lowercased())
        }
    }
        
    @AppStorage("showExactDates") private var showExactDates: Bool = false
    
    var body: some View {
        @Bindable var viewModelState = viewModel
        
        NavigationStack {
            root
                .navigationTitle(Text("LABEL_PANTRY"))
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("ACTION_ADD", systemImage: "plus") {
                            viewModel.showAddSheet = true
                        }
                    }
                    
                    ToolbarItem(placement: .secondaryAction) {
                        /*Divider()*/
                        Toggle(labelShowExactDate, isOn: $showExactDates)
                    }
                }
                .sheet(isPresented: $viewModelState.showAddSheet) {
                    PantryEditItemView()
                }
        }
    }
    
    @ViewBuilder
    private var root: some View {
        @Bindable var viewModelState = viewModel
        
        if items.isEmpty {
            ContentUnavailableView(noticeLabelNoItems, systemImage: "carrot.fill", description: Text(noticeContentNoItems))
        } else {
            List {
                ForEach(filteredItems, id: \.self) { item in
                    PantryItemRow(item: item)
                }
            }
            .searchable(text: $viewModelState.searchTerm)
        }
    }
}

extension PantryNavigationStack {
    var noticeLabelNoItems: String {
        .init(
            localized: "NOTICE_LABEL_NO_ITEMS",
            defaultValue: "No Items",
            table: "Pantry"
        )
    }
    
    var noticeContentNoItems: String {
        .init(
            localized: "NOTICE_CONTENT_NO_RECIPES",
            defaultValue: "Your pantry is empty. Add some items to get started.",
            table: "Pantry"
        )
    }
    
    var labelShowExactDate: String {
        .init(
            localized: "LABEL_SHOW_EXACT_DATE",
            defaultValue: "Show Exact Date",
            table: "Pantry",
            comment: "This label is connected to a toggle that when pressed, changes the display format."
        )
    }
}

#Preview("Items") {
    PantryNavigationStack()
        .previewFilledContainer()
        .environment(PantryViewModel())
}

#Preview("No Items") {
    PantryNavigationStack()
        .previewEmptyContainer()
        .environment(PantryViewModel())
}
