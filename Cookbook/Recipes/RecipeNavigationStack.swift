//
//  RecipeNavigationStack.swift
//  Cookbook
//
//  Created by Neo Salmon on 02/12/2023.
//

import SwiftUI
import SwiftData
import CookbookRecipesKit

struct RecipeNavigationStack: View {
    @Environment(RecipeViewModel.self) var viewModel: RecipeViewModel
    
    @Query private var recipes: [Recipe]
    
    var body: some View {
        @Bindable var viewModelState = viewModel
        
        NavigationStack(path: $viewModelState.navigationState) {
            root
                .navigationTitle("LABEL_RECIPES")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        if recipes.isEmpty {
                            EmptyView()
                        } else {
                            EditButton()
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            viewModel.showCreateRecipe = true
                        } label: {
                            Label(actionCreateRecipe, systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $viewModelState.showCreateRecipe) {
                    CreateRecipeNavigationStack()
                }
                .fullScreenCover(item: $viewModelState.activeRecipe) { recipe in
                    Text(recipe.name)
                }
        }
    }
    
    @ViewBuilder
    private var root: some View {
        @Bindable var viewModelState = viewModel
        
        if recipes.isEmpty {
            ContentUnavailableView(
                noticeLabelNoRecipes,
                systemImage: "list.bullet.clipboard.fill",
                description: Text(noticeContentNoRecipes)
            )
        } else {
            List {
                ForEach(recipes, id: \.id) { recipe in
                    NavigationLink(value: recipe) {
                        RecipeRowView(recipe: recipe)
                    }
                }
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .searchable(text: $viewModelState.searchTerm)
        }
    }
}

extension RecipeNavigationStack {
    var noticeLabelNoRecipes: String {
        .init(
            localized: "NOTICE_LABEL_NO_RECIPES",
            defaultValue: "No Recipes",
            table: "Recipes"
        )
    }
    
    var noticeContentNoRecipes: String {
        .init(
            localized: "NOTICE_CONTENT_NO_RECIPES",
            defaultValue: "You have not saved any recipes.",
            table: "Recipes"
        )
    }
    
    var actionCreateRecipe: String {
        .init(
            localized: "ACTION_CREATE_RECIPE",
            defaultValue: "Create Recipe",
            table: "Recipes"
        )
    }
}

#Preview("Recipes") {
    RecipeNavigationStack()
        .previewFilledContainer()
        .environment(RecipeViewModel())
}

#Preview("No Recipes") {
    RecipeNavigationStack()
        .previewEmptyContainer()
        .environment(RecipeViewModel())
}
