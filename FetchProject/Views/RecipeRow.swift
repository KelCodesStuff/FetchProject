//
//  RecipeRow.swift
//  FetchProject
//
//  Created by Kelvin Reid on 2/4/25.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    @State private var image: UIImage?
    
    var body: some View {
        HStack {
            // Check if a small photo URL exists
            if let url = recipe.photoURLSmall {
                Image(uiImage: image ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .onAppear {
                        Task {
                            // Load the image asynchronously
                            image = try? await ImageCache.shared.loadImage(from: url)
                        }
                    }
            }
            // Arrange the recipe name and cuisine vertically
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
            }
        }
    }
}

