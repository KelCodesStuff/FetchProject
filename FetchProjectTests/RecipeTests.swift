//
//  FetchProjectTests.swift
//  FetchProjectTests
//
//  Created by Kelvin Reid on 2/4/25.
//

import XCTest
@testable import FetchProject

@MainActor
final class RecipeTests: XCTestCase {
    // Declare properties for the network manager and view model
    var networkManager: NetworkManager!
    var viewModel: RecipeListViewModel!
    
    // Example URL for testing purposes
    let mockURL = URL(string: "https://example.com/recipe")!

    // Set up method to initialize the network manager and view model before each test
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager()
        viewModel = RecipeListViewModel()
    }

    // Tear down method to deallocate the network manager and view model after each test to avoid memory leaks and ensure a clean state
    override func tearDown() {
        networkManager = nil
        viewModel = nil
        super.tearDown()
    }

    // Test to verify successful fetching of recipes
    func testFetchRecipesSuccess() async throws {
        let recipes = try await networkManager.fetchRecipes()
        // Assert that the recipes array is not empty
        XCTAssertFalse(recipes.isEmpty, "Recipes array should not be empty")

        // Iterate through the fetched recipes and assert that each recipe has valid data
        for recipe in recipes {
            XCTAssertNotNil(recipe.id, "Recipe ID should not be nil")
            XCTAssertNotNil(recipe.name, "Recipe name should not be nil")
            XCTAssertNotNil(recipe.cuisine, "Recipe cuisine should not be nil")
            XCTAssertNotNil(recipe.photoURL, "Recipe photo URL should not be nil")
            XCTAssertNotNil(recipe.photoURLSmall, "Recipe small photo URL should not be nil")
        }
    }

    // Test to verify handling of malformed data in the recipes response
    func testFetchRecipesMalformed() async throws {
        // Use the AssertThrowsErrorAsync helper function to check if the fetchRecipesMalformed method throws the expected error
        await AssertThrowsErrorAsync(
            { try await self.networkManager.fetchRecipesMalformed() },
            "Expected a malformed data error to be thrown."
        ) { error in
            // Assert that the thrown error is of type NetworkManager.NetworkError and has the value malformedData
            XCTAssertEqual(error as? NetworkManager.NetworkError, .malformedData, "Error should be malformedData")
        }
    }

    // Test to verify successful fetching of recipes using the view model
    func testViewModelFetchRecipesSuccess() async throws {
        // Call the fetchRecipes method of the view model
        await viewModel.fetchRecipes()
        // Assert that the recipes array in the view model is not empty
        XCTAssertFalse(viewModel.recipes.isEmpty, "View model recipes should not be empty")
        // Assert that the error message in the view model is nil
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil")
    }

    // Test case to verify image caching functionality
    func testImageCaching() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/1990117c-dcb1-41aa-bdaf-562b23bdf3d0/large.jpg")!
        // Load the image from the URL using the ImageCache
        let image = try? await ImageCache.shared.loadImage(from: url)
        // Assert that the loaded image is not nil
        XCTAssertNotNil(image, "Image should not be nil")

        // Load the same image again from the cache
        let cachedImage = try? await ImageCache.shared.loadImage(from: url)
        // Assert that the cached image is not nil
        XCTAssertNotNil(cachedImage, "Cached image should not be nil")
        // Assert that the cached image is the same as the original image
        XCTAssertEqual(image?.pngData(), cachedImage?.pngData(), "Images should be equal (cached)")
    }

    // Test case for image download failure
    func testImageDownloadFailure() async throws {
        // Example of an invalid URL
        let invalidURL = URL(string: "https://invalid-url.com/image.jpg")!
        let image = try? await ImageCache.shared.loadImage(from: invalidURL)
        XCTAssertNil(image, "Image download should fail for invalid URL")
    }
}


// Helper function to simplify testing for asynchronous errors.
// It checks if the provided expression throws an error and allows you to perform assertions on the error that is thrown
func AssertThrowsErrorAsync<T>(
    _ expression: @escaping () async throws -> T,
    _ message: String = "Expected error to be thrown",
    file: StaticString = #file,
    line: UInt = #line,
    _ errorHandler: @escaping (Error) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
        XCTFail(message, file: file, line: line)
    } catch {
        errorHandler(error)
    }
}
