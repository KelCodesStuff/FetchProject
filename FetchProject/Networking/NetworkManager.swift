//
//  NetworkManager.swift
//  FetchProject
//
//  Created by Kelvin Reid on 2/4/25.
//

import Foundation
import UIKit

class NetworkManager {
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    private let session = URLSession.shared
    
    // Custom error enum for handling network issues
    enum NetworkError: Error {
        case invalidURL
        case dataNotFound
        case decodingError
        case malformedData
    }
    
    // Function to fetch recipes from the API
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: "\(baseURL)/recipes.json") else {
            throw NetworkError.invalidURL
        }
        
        // Make the network request
        let (data, response) = try await session.data(from: url)
        
        // Check for a successful HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.dataNotFound
        }
        
        // Decode the JSON data into a 'RecipesResponse' object
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(RecipesResponse.self, from: data) // Decode the new struct
            return response.recipes
        } catch {
            if error is DecodingError {
                throw NetworkError.malformedData
            } else {
                throw NetworkError.decodingError
            }
        }
    }
    
    // Function to fetch recipes from a URL where the JSON might be empty
    func fetchRecipesEmpty() async throws -> [Recipe] {
        guard let url = URL(string: "\(baseURL)/recipes-empty.json") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.dataNotFound
        }
        
        do {
            let decoder = JSONDecoder()
            // Try decoding. If it succeeds, it means the JSON is valid, even if it's empty.
            let recipes = try decoder.decode([Recipe].self, from: data)
            return recipes // Return the (potentially empty) recipes array.
            
        } catch let error as DecodingError {
            // Only throw malformedData if the error indicates a structural issue.
            if case .typeMismatch = error, // Check if the error is a type mismatch.
               case .keyNotFound = error, // Check if the error is a key not found.
               case .valueNotFound = error { // Check if the error is a value not found.
                throw NetworkError.malformedData
            } else {
                throw NetworkError.decodingError // Some other decoding error.
            }
        } catch {
            throw NetworkError.decodingError // Some other decoding error.
        }
    }
    
    // Function to fetch recipes from a URL where the JSON might be malformed
    func fetchRecipesMalformed() async throws -> [Recipe] {
        guard let url = URL(string: "\(baseURL)/recipes-malformed.json") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.dataNotFound
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Recipe].self, from: data)
        } catch {
            // Check if the error is a type mismatch, indicating malformed data
            if error is DecodingError {
                throw NetworkError.malformedData
            } else {
                throw NetworkError.decodingError
            }
        }
    }
}
