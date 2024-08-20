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
    
    /// Initializes the view model with a specific dessert service.
    /// - Parameter dessertService: The dessert service to be used for fetching data. Defaults to `DessertService.shared`.
    init(dessertService: DessertServiceProtocol = DessertService.shared) {
        self.dessertService = dessertService
    }
    
    /// Loads the list of desserts from the service.
    func loadDesserts() async {
        do {
            let fetchedDesserts = try await dessertService.fetchDesserts()
            self.desserts = fetchedDesserts
        } catch {
            await ErrorHandler.shared.report(error: error)
        }
    }
    
    /// Updates the search query and filters the desserts based on it.
    /// - Parameter query: The search query to filter desserts.
    func updateSearchQuery(_ query: String) {
        searchQuery = query
    }
    
    /// The filtered list of desserts based on the search query.
    var filteredDesserts: [Dessert] {
        if searchQuery.isEmpty {
            return desserts
        } else {
            return desserts.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
    }
}
