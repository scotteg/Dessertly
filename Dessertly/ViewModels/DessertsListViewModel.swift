//
//  DessertsListViewModel.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation

/// Manages a list of desserts.
actor DessertsListViewModel {
    private let dessertService: DessertServiceProtocol
    private(set) var allDesserts: [Dessert] = []
    private(set) var filteredDesserts: [Dessert] = []
    private(set) var isLoading = true
    private(set) var errorMessage: String?
    
    init(dessertService: DessertServiceProtocol = DessertService.shared) {
        self.dessertService = dessertService
    }
    
    func loadDesserts() async {
        isLoading = true
        
        do {
            allDesserts = try await dessertService.fetchDesserts()
            filteredDesserts = allDesserts
        } catch let error as DessertServiceError {
            await ErrorHandler.shared.report(error: error)
            errorMessage = error.localizedDescription
        } catch {
            await ErrorHandler.shared.report(error: error)
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func getFilteredDesserts(searchQuery: String) async {
        if searchQuery.isEmpty {
            filteredDesserts = allDesserts
        } else {
            filteredDesserts = allDesserts.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    var hasError: Bool {
        errorMessage != nil
    }
}
