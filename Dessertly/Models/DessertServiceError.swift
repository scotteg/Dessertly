//
//  DessertServiceError.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/27/24.
//

import Foundation

/// Represents possible errors in `DessertService`.
enum DessertServiceError: Error {
    case badURL
    case badServerResponse
    case decodingError
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "The URL is invalid."
        case .badServerResponse:
            return "The server response was invalid."
        case .decodingError:
            return "Failed to decode the response."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
