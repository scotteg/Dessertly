//
//  DessertResponse.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation

/// A response from the `DessertService` that includes a `meals` array of `Dessert`s.
struct DessertResponse: Codable {
    let meals: [Dessert]
}
