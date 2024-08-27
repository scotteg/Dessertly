//
//  DessertDetailViewModel.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation

/// Manages the details of a dessert.
actor DessertDetailViewModel {
    private let dessertService: DessertServiceProtocol
    private(set) var dessertDetail: DessertDetail?
    private(set) var isLoading = true
    private(set) var errorMessage: String?
    
    init(dessertService: DessertServiceProtocol = DessertService.shared) {
        self.dessertService = dessertService
    }
    
    func loadDessertDetail(dessertID: String) async {
        isLoading = true
        
        do {
            dessertDetail = try await dessertService.fetchDessertDetail(by: dessertID)
        } catch {
            errorMessage = error.localizedDescription
            await ErrorHandler.shared.report(error: error)
        }
        
        isLoading = false
    }
    
    func sortIngredients(ingredients: [String: String], ascending: Bool) -> [(ingredient: String, measure: String)] {
        let sorted = ingredients.map { ($0.key, $0.value) }
            .sorted { ascending ? $0.0.lowercased() < $1.0.lowercased() : $0.0.lowercased() > $1.0.lowercased() }
        return sorted
    }
    
    var hasError: Bool {
        errorMessage != nil
    }
}
