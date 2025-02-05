//
//  RecipeDetailView.swift
//  FetchProject
//
//  Created by Kelvin Reid on 2/4/25.
//

import SwiftUI

// This defines the view for a single recipe
struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var image: UIImage?
    
    var body: some View {
        // Use a scroll view to allow scrolling if the content is too large
        ScrollView {
            VStack(alignment: .leading) {
                // Check if a photo URL exists
                if let url = recipe.photoURL {
                    // Display the image or placeholder if not loaded yet
                    Image(uiImage: image ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            Task {
                                image = try? await ImageCache.shared.loadImage(from: url)
                            }
                        }
                }
                // Recipe info
                Text(recipe.name)
                    .font(.title)
                Text(recipe.cuisine)
                    .font(.headline)
            }
            .padding()
        }
        // Set the title of the navigation bar
        .navigationTitle(recipe.name)
    }
}
#Preview {
    RecipeListView()
}

