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
    var isLoading = true
    var errorMessage: String?
    
    init(dessertService: DessertServiceProtocol = DessertService.shared) {
        self.dessertService = dessertService
    }
    
    func loadDessertDetail(dessertID: String) async {
        do {
            dessertDetail = try await dessertService.fetchDessertDetail(by: dessertID)
        } catch {
            await ErrorHandler.shared.report(error: error)
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func sortIngredients(ingredients: [String: String], ascending: Bool) -> [(ingredient: String, measure: String)] {
        let ingredientsArray = ingredients.map { ($0.key, $0.value) }
        let sortedIngredients = ingredientsArray.sorted { $0.0.lowercased() < $1.0.lowercased() }
        return ascending ? sortedIngredients : sortedIngredients.reversed()
    }
    
    var hasError: Bool {
        errorMessage != nil
    }
}
