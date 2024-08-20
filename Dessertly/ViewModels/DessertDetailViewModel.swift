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
}
