//
//  DessertDetailViewModelTests.swift
//  DessertlyTests
//
//  Created by Scott Gardner on 8/19/24.
//

import XCTest
@testable import Dessertly

/// Tests for `DessertDetailViewModel` to ensure it correctly loads and manages dessert details.
final class DessertDetailViewModelTests: XCTestCase {
    private var viewModel: DessertDetailViewModel!
    private var mockService: MockDessertService!
    
    override func setUp() {
        super.setUp()
        mockService = MockDessertService()
        viewModel = DessertDetailViewModel(dessertService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    /// Tests successful loading of dessert details.
    func testLoadDessertDetailSuccess() async {
        // Given
        let dessertID = "1"
        
        // When
        await viewModel.loadDessertDetail(dessertID: dessertID)
        
        // Then
        let dessertDetail = await viewModel.dessertDetail
        XCTAssertNotNil(dessertDetail)
        XCTAssertEqual(dessertDetail?.name, "Mock Dessert")
    }
    
    /// Tests loading dessert details with a failure scenario.
    func testLoadDessertDetailFailure() async {
        // Given
        mockService = MockDessertService(shouldThrow: true)
        viewModel = DessertDetailViewModel(dessertService: mockService)
        
        // When
        await viewModel.loadDessertDetail(dessertID: "1")
        
        // Then
        let currentError = await ErrorHandler.shared.getCurrentError()
        XCTAssertNotNil(currentError)
    }
}
