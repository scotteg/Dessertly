//
//  DessertServiceProtocol.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation

/// Protocol that defines the requirements to fetch dessert data.
protocol DessertServiceProtocol {
    
    /// Asynchronously fetches a list of desserts.
    /// - Returns: An array of `Dessert` instances.
    /// - Throws: An error if the data fetching or decoding fails.
    func fetchDesserts() async throws -> [Dessert]
    
    /// Asynchronously fetches detailed information for a specific dessert by its ID.
    /// - Parameter id: The ID of the dessert to fetch details for.
    /// - Returns: A `DessertDetail` instance containing detailed information about the dessert.
    /// - Throws: An error if the data fetching or decoding fails.
    func fetchDessertDetail(by id: String) async throws -> DessertDetail
}
