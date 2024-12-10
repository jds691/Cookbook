//
//  RecipeRowView.swift
//  Cookbook
//
//  Created by Neo Salmon on 02/12/2023.
//

import SwiftUI
import CookbookRecipesKit

struct RecipeRowView: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            if let previewImageData = recipe.previewImage {
                Image(uiImage: .init(data: previewImageData) ?? .init())
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
            }
        }
        
    }
}

#Preview {
    List {
        RecipeRowView(recipe: .preview)
    }
    .previewEmptyContainer()
}
