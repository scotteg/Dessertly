//
//  DessertsListViewModelTests.swift
//  DessertlyTests
//
//  Created by Scott Gardner on 8/19/24.
//

import XCTest
@testable import Dessertly

/// Tests for `DessertsListViewModel` to ensure it correctly loads and manages desserts.
final class DessertsListViewModelTests: XCTestCase {
    private var viewModel: DessertsListViewModel!
    private var mockService: MockDessertService!
    
    override func setUp() {
        super.setUp()
        mockService = MockDessertService()
        viewModel = DessertsListViewModel(dessertService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    /// Tests successful loading of desserts.
    func testLoadDessertsSuccess() async {
        // When
        await viewModel.loadDesserts()
        
        // Then
        let desserts = await viewModel.allDesserts
        XCTAssertEqual(desserts.count, 2)
        XCTAssertEqual(desserts[0].name, "Mock Dessert 1")
        XCTAssertEqual(desserts[1].name, "Mock Dessert 2")
    }
    
    /// Tests loading desserts with a failure scenario.
    func testLoadDessertsFailure() async {
        // Given
        mockService = MockDessertService(shouldThrow: true)
        viewModel = DessertsListViewModel(dessertService: mockService)
        
        // When
        await viewModel.loadDesserts()
        
        // Then
        let currentError = await ErrorHandler.shared.getCurrentError()
        XCTAssertNotNil(currentError)
    }
}
