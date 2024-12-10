//
//  RecipeDetailView.swift
//  Cookbook
//
//  Created by Neo Salmon on 02/12/2023.
//

import SwiftUI
import CookbookRecipesKit

struct RecipeDetailView: View {
    @Environment(RecipeViewModel.self) var viewModel: RecipeViewModel
    
    var recipe: Recipe
    
    var body: some View {
        ScrollView {
            headerImage
            VStack(alignment: .leading) {
                metadata
                ingrediants
                    .padding(.top)
            }
            .scenePadding()
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    viewModel.beginMaking(recipe: recipe)
                } label: {
                    Text(actionMakeRecipe)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    @ViewBuilder
    private var headerImage: some View {
        if let previewImageData = recipe.previewImage, let uiImage = UIImage(data: previewImageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .mask(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .black, location: 0),
                    .init(color: .black, location: 0.6),
                    .init(color: .clear, location: 1),
                ]), startPoint: .top, endPoint: .bottom))
                .drawingGroup()
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var metadata: some View {
        Text(recipe.name)
            .bold()
            .font(.title)
        /*HStack {
            HStack {
                Image(systemName: "stopwatch")
                VStack(alignment: .leading) {
                    Text("Cook Time")
                    Text("5 mins")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .foregroundStyle(.secondary, .tertiary)*/
        Divider()
        Text(recipe.details)
    }
    
    @ViewBuilder
    private var ingrediants: some View {
        Section {
            /*ForEach(recipe.ingredients, id: \.self) { ingredient in
                Text("- \(ingredient)")
            }*/
        } header: {
            Text(labelIngredients)
                .bold()
                .font(.title2)
        }
    }
}

//MARK: Localization
extension RecipeDetailView {
    var labelIngredients: LocalizedStringResource {
        .init(
            "LABEL_INGREDIENTS",
            defaultValue: "Ingredients",
            table: "Recipes"
        )
    }
    
    var actionMakeRecipe: LocalizedStringResource {
        .init(
            "ACTION_MAKE_RECIPE",
            defaultValue: "Let's Make It!",
            table: "Recipes"
        )
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: .preview)
            .environment(RecipeViewModel())
    }
}
