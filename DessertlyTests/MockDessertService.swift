//
//  MockDessertService.swift
//  DessertlyTests
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation
@testable import Dessertly

/// Mock implementation of `DessertServiceProtocol` for unit testing.
final class MockDessertService: DessertServiceProtocol {
    private let shouldThrow: Bool
    
    init(shouldThrow: Bool = false) {
        self.shouldThrow = shouldThrow
    }
    
    /// Simulates fetching a list of desserts.
    /// - Returns: An array of mock `Dessert` instances.
    func fetchDesserts() async throws -> [Dessert] {
        if shouldThrow {
            throw URLError(.badServerResponse)
        }
        return [
            Dessert(id: "1", name: "Mock Dessert 1", thumbnail: ""),
            Dessert(id: "2", name: "Mock Dessert 2", thumbnail: "")
        ]
    }
    
    /// Simulates fetching detailed information for a specific dessert by its ID.
    /// - Parameter id: The ID of the dessert to fetch details for.
    /// - Returns: A mock `DessertDetail` instance containing mock data.
    func fetchDessertDetail(by id: String) async throws -> DessertDetail {
        if shouldThrow {
            throw URLError(.badServerResponse)
        }
        return DessertDetail(
            id: id,
            name: "Mock Dessert",
            instructions: "Add sugar, then flour, and finally eggs. Mix well.",
            ingredients: ["Sugar": "1 cup", "Flour": "2 cups", "Eggs": "2 large"],
            imageUrl: ""
        )
    }
}
