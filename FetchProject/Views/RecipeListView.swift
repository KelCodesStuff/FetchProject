//
//  RecipeListView.swift
//  FetchProject
//
//  Created by Kelvin Reid on 2/4/25.
//

import SwiftUI

// Main view for displaying a list of recipes
struct RecipeListView: View {
    @StateObject var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // Show a progress view while loading recipes
                if viewModel.isLoading {
                    ProgressView()
                    
                // Show an error message if fetching recipes fails
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                    
                // Show a message if no recipes are found
                } else if viewModel.recipes.isEmpty {
                    Text("No recipes found.")
                } else {
                    // Display the list of recipes
                    ForEach(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRow(recipe: recipe)
                        }
                    }
                }
            }
            // Title of the navigation bar
            .navigationTitle("Recipes")
            .toolbar {
                Button(action: {
                    Task {
                        await viewModel.fetchRecipes()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .task {
                await viewModel.fetchRecipes()
            }
        }
    }
}



