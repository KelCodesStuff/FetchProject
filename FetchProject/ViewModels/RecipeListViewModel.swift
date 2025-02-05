//
//  RecipeListViewModel.swift
//  FetchProject
//
//  Created by Kelvin Reid on 2/4/25.
//

import SwiftUI

class RecipeListViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String? = nil

    // Dependency injection for network requests
    // This makes testing easier by mocking the NetworkManager
    var networkManager = NetworkManager()
    
    init(networkManager: NetworkManager = NetworkManager()) {
            self.networkManager = networkManager
        }
    
    // Uses a shared image cache to improve performance by storing downloaded images
    private let imageCache = ImageCache.shared
    

    // Main actor to ensure UI updates are performed on the main thread
    @MainActor
    func fetchRecipes() async {
        isLoading = true
        errorMessage = nil

        // Fetch the recipes using the NetworkManager
        do {
            recipes = try await networkManager.fetchRecipes()
        } catch let error as NetworkManager.NetworkError {
            switch error {
            case .malformedData:
                errorMessage = "The recipe data is malformed."
            case .dataNotFound:
                errorMessage = "No recipes were found."
            default:
                errorMessage = "An error occurred while fetching recipes."
            }
            recipes = [] // Clear recipes if there's an error
        } catch {
            errorMessage = "An unexpected error occurred."
            recipes = []
        }

        isLoading = false
    }

    // Function for testing error handling
    @MainActor
    func fetchRecipesEmpty() async {
        isLoading = true
        errorMessage = nil

        do {
            recipes = try await networkManager.fetchRecipesEmpty()
        } catch let error as NetworkManager.NetworkError {
            switch error {
            case .malformedData:
                errorMessage = "The recipe data is malformed."
            case .dataNotFound:
                errorMessage = "No recipes were found."
            default:
                errorMessage = "An error occurred while fetching recipes."
            }
            recipes = []
        } catch {
            errorMessage = "An unexpected error occurred."
            recipes = []
        }

        isLoading = false
    }

    // Function for testing error handling
    @MainActor
    func fetchRecipesMalformed() async {
        isLoading = true
        errorMessage = nil

        do {
            recipes = try await networkManager.fetchRecipesMalformed()
        } catch let error as NetworkManager.NetworkError {
            switch error {
            case .malformedData:
                errorMessage = "The recipe data is malformed."
            case .dataNotFound:
                errorMessage = "No recipes were found."
            default:
                errorMessage = "An error occurred while fetching recipes."
            }
            recipes = []
        } catch {
            errorMessage = "An unexpected error occurred."
            recipes = []
        }

        isLoading = false
    }


    // Loads an image from a URL using the ImageCache
    func loadImage(from url: URL?) async throws -> UIImage? {
        guard let url = url else { return nil }
        return try await imageCache.loadImage(from: url)
    }
}


