//
//  RecipeEntity.swift
//  CookbookIntents
//
//  Created by Neo Salmon on 07/12/2023.
//

import AppIntents
import CookbookRecipesKit

struct RecipeEntity: AppEntity {
    public let id: UUID
    public let name: String
    public let thumbnailData: Data?
    
    //MARK: AppEntity
    public static var defaultQuery = RecipeQuery()
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "RecipeEntity.typeDisplayRepresentation"
    
    public var displayRepresentation: DisplayRepresentation {
        if let imageData = thumbnailData {
            .init(
                title: LocalizedStringResource(stringLiteral: self.name),
                image: .init(data: imageData)
            )
        } else {
            .init(
                title: LocalizedStringResource(stringLiteral: self.name),
                image: .init(systemName: "list.bullet.clipboard.fill")
            )
        }
        
    }
    
    public init(_ recipe: Recipe) {
        self.id = recipe.id
        self.name = recipe.name
        self.thumbnailData = recipe.previewImage
    }
}
