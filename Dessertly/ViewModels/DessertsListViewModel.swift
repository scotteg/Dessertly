//
//  DessertsListViewModel.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation

/// View model responsible for fetching and managing a list of desserts.
actor DessertsListViewModel {
    private let dessertService: DessertServiceProtocol
    private(set) var desserts: [Dessert] = []
    private(set) var searchQuery: String = ""
    private(set) var isLoading = true
    private(set) var errorMessage: String?
    
    init(dessertService: DessertServiceProtocol = DessertService.shared) {
        self.dessertService = dessertService
    }
    
    func loadDesserts() async {
        do {
            let fetchedDesserts = try await dessertService.fetchDesserts()
            self.desserts = fetchedDesserts
        } catch {
            await ErrorHandler.shared.report(error: error)
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    func updateSearchQuery(_ query: String) {
        searchQuery = query
    }
    
    var filteredDesserts: [Dessert] {
        if searchQuery.isEmpty {
            return desserts
        } else {
            return desserts.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    var isEmpty: Bool {
        return desserts.isEmpty && !isLoading
    }
    
    var hasError: Bool {
        return errorMessage != nil
    }
}
