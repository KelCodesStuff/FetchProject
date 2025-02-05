//
//  Recipe.swift
//  FetchProject
//
//  Created by Kelvin Reid on 2/4/25.
//

import Foundation

// Recipe properties
struct Recipe: Identifiable, Decodable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoURL: URL?
    let photoURLSmall: URL?
    
    // Defines the keys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURL = "photo_url_large"
        case photoURLSmall = "photo_url_small"
    }
    
    // Custom initializer to handle optional URL strings and convert them to URL objects
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        cuisine = try values.decode(String.self, forKey: .cuisine)
        
        // Decode the photoURL string if present and convert it to a URL
        let photoURLString = try values.decodeIfPresent(String.self, forKey: .photoURL)
        photoURL = photoURLString != nil ? URL(string: photoURLString!) : nil
        
        // Decode the photoURLSmall string if present and convert it to a URL
        let photoURLSmallString = try values.decodeIfPresent(String.self, forKey: .photoURLSmall)
        photoURLSmall = photoURLSmallString != nil ? URL(string: photoURLSmallString!) : nil
    }
}

// Response containing an array of recipes
struct RecipesResponse: Decodable {
    let recipes: [Recipe]
}
