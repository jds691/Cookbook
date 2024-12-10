//
//  CreateRecipeView.swift
//  Cookbook
//
//  Created by Neo Salmon on 02/12/2023.
//

import SwiftUI
import CookbookRecipesKit

struct CreateRecipeNavigationStack: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var showCancellationDialog: Bool = false
    
    @State private var recipe: Recipe = Recipe()
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    ZStack {
                        Rectangle()
                            //.resizable()
                            .scaledToFit()
                            .frame(maxHeight: 75)
                        
                        MediaPickerView {
                            ZStack {
                                Image(systemName: "camera")
                                    .foregroundStyle(.black)
                                    .scenePadding()
                                    .background(
                                        Circle()
                                            .foregroundStyle(.ultraThinMaterial)
                                    )
                            }
                        }
                    }
                    
                    TextField("LABEL_NAME", text: $recipe.name)
                }
                
                
                Section ("LABEL_ITEMS") {
                    Button {
                        
                    } label: {
                        Label("ACTION_ADD_ITEM", systemImage: "plus")
                    }
                }
            }
            .navigationTitle(Text(labelCreateRecipe))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("ACTION_CANCEL") {
                        showCancellationDialog = true
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("ACTION_CREATE") {
                        Task {
                            await storeRecipe()
                        }
                    }
                }
            }
            .confirmationDialog(noticeContentDiscardRecipe, isPresented: $showCancellationDialog, actions: {
                Button(role: .destructive, action: {cancel()}) {
                    Text("ACTION_DISCARD")
                }}, message: {
                    Text(noticeLabelDiscardRecipe)
                })
            .interactiveDismissDisabled()
        }
    }
    
    private func cancel() {
        dismiss()
    }
    
    private func storeRecipe() async {
        dismiss()
        
        //modelContext.insert(recipe)
        //RecipeController.shared.indexRecipe(recipe)
    }
}

extension CreateRecipeNavigationStack {
    var labelCreateRecipe: LocalizedStringResource {
        .init(
            "LABEL_CREATE_RECIPE",
            defaultValue: "Create Recipe",
            table: "Recipes"
        )
    }
    
    //TODO: Replace with global generic version at some point
    var noticeLabelDiscardRecipe: String {
        .init(
            localized: "NOTICE_LABEL_DISCARD_RECIPE",
            defaultValue: "This action cannot be undone.",
            table: "Recipes"
        )
    }
    
    var noticeContentDiscardRecipe: String {
        .init(
            localized: "NOTICE_CONTENT_DISCARD_RECIPE",
            defaultValue: "Are you sure you discard this recipe?",
            table: "Recipes"
        )
    }
}

#Preview {
    CreateRecipeNavigationStack()
        .previewEmptyContainer()
}
