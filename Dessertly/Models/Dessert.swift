//
//  Dessert.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation

/// Represents a dessert item.
struct Dessert: Identifiable, Codable {
    let id: String
    let name: String

    /// URL string for the dessert's thumbnail image.
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnail = "strMealThumb"
    }
}
