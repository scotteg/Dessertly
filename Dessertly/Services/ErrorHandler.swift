//
//  ErrorHandler.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/19/24.
//

import Foundation

/// An actor responsible for managing and reporting errors across the app.
actor ErrorHandler {
    static let shared = ErrorHandler()

    private var _currentError: Error?

    private init() {}

    /// Reports an error to the centralized error handler.
    /// - Parameter error: The error to report.
    func report(error: Error) async {
        _currentError = error
    }

    /// Retrieves the current error.
    /// - Returns: The current error, if any.
    func getCurrentError() async -> Error? {
        return _currentError
    }

    /// Clears the current error.
    func clearError() async {
        _currentError = nil
    }
}
