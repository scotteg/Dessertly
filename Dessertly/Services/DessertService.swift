//
//  DessertService.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation

/// An actor that conforms to `DessertServiceProtocol` and handles fetching desserts and their details.
actor DessertService: DessertServiceProtocol {
    static let shared = DessertService()
    
    private let scheme = "https"
    private let host = "www.themealdb.com"
    private let basePath = "/api/json/v1/1/"
    
    private init() {}
    
    /// Fetches a list of desserts from the remote API.
    /// - Returns: A sorted array of `Dessert` objects.
    /// - Throws: An error if the data fetching or decoding fails.
    func fetchDesserts() async throws -> [Dessert] {
        do {
            guard let url = makeURL(endpoint: "filter.php", queryItems: [URLQueryItem(name: "c", value: "Dessert")]) else {
                let error = URLError(.badURL)
                await ErrorHandler.shared.report(error: error)
                throw error
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let dessertResponse = try JSONDecoder().decode(DessertResponse.self, from: data)
            return dessertResponse.meals.sorted { $0.name < $1.name }
        } catch {
            await ErrorHandler.shared.report(error: error)
            throw error
        }
    }
    
    /// Fetches the details of a specific dessert by its ID.
    /// - Parameter id: The unique identifier of the dessert.
    /// - Returns: A `DessertDetail` object containing detailed information about the dessert.
    /// - Throws: An error if the URL is invalid, data fetching fails, or decoding fails.
    func fetchDessertDetail(by id: String) async throws -> DessertDetail {
        do {
            guard let url = makeURL(endpoint: "lookup.php", queryItems: [URLQueryItem(name: "i", value: id)]) else {
                let error = URLError(.badURL)
                await ErrorHandler.shared.report(error: error)
                throw error
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let detailResponse = try JSONDecoder().decode(DessertDetailResponse.self, from: data)
            
            guard let rawDetail = detailResponse.meals.first else {
                let error = URLError(.badServerResponse)
                await ErrorHandler.shared.report(error: error)
                throw error
            }
            
            return DessertDetail(
                id: rawDetail.id,
                name: rawDetail.name,
                instructions: rawDetail.instructions,
                ingredients: rawDetail.ingredients,
                imageUrl: rawDetail.imageUrl
            )
        } catch {
            await ErrorHandler.shared.report(error: error)
            throw error
        }
    }
    
    /// Constructs a URL from the given endpoint and query items using URLComponents.
    /// - Parameters:
    ///   - endpoint: The API endpoint.
    ///   - queryItems: An array of `URLQueryItem` to be added to the URL.
    /// - Returns: A fully constructed `URL` or `nil` if the URL is invalid.
    private func makeURL(endpoint: String, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = basePath + endpoint
        components.queryItems = queryItems
        
        return components.url
    }
}
