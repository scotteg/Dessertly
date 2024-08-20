//
//  DessertDetailViewModel.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation

/// View model responsible for fetching and managing the details of a specific dessert.
actor DessertDetailViewModel {
    private let dessertService: DessertServiceProtocol
    var dessertDetail: DessertDetail?
    
    /// Initializes the view model with a specific dessert service.
    /// - Parameter dessertService: The dessert service to be used for fetching data. Defaults to `DessertService.shared`.
    init(dessertService: DessertServiceProtocol = DessertService.shared) {
        self.dessertService = dessertService
    }
    
    /// Loads the details of a specific dessert by its ID.
    /// - Parameter dessertID: The ID of the dessert to fetch details for.
    func loadDessertDetail(dessertID: String) async {
        do {
            let detail = try await dessertService.fetchDessertDetail(by: dessertID)
            self.dessertDetail = detail
        } catch {
            await ErrorHandler.shared.report(error: error)
        }
    }
    
    /// Sorts the ingredients either in ascending or descending order.
    /// - Parameters:
    ///   - ingredients: A dictionary of ingredients and their measurements.
    ///   - ascending: A boolean value indicating whether the sorting should be ascending or descending.
    /// - Returns: A sorted array of tuples containing the ingredient and its measurement.
    func sortIngredients(ingredients: [String: String], ascending: Bool) -> [(ingredient: String, measure: String)] {
        let ingredientsArray = ingredients.map { ($0.key, $0.value) }
        let sortedIngredients = ingredientsArray.sorted { $0.0.lowercased() < $1.0.lowercased() }
        return ascending ? sortedIngredients : sortedIngredients.reversed()
    }
}
