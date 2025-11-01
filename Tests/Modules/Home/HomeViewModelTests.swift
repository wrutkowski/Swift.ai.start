import XCTest
@testable import SwiftUIViperApp

final class HomeViewModelTests: XCTestCase {
  func testLoadItemsSuccess() async {
    // Given
    let interactor = MockHomeInteractor()
    let viewModel = HomeViewModel(interactor: interactor)
    
    // When
    await viewModel.loadItems()
    
    // Then
    XCTAssertEqual(viewModel.items.count, 3, "Should have 3 items")
    XCTAssertEqual(viewModel.items[0].name, "Test 1", "First item should be Test 1")
    XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
    XCTAssertNil(viewModel.errorMessage, "Should have no error message")
  }
  
  func testLoadItemsShowsLoadingState() async {
    // Given
    let interactor = MockHomeInteractor()
    let viewModel = HomeViewModel(interactor: interactor)
    
    // When - start loading
    let task = Task {
      await viewModel.loadItems()
    }
    
    // Then - should be loading
    XCTAssertTrue(viewModel.isLoading, "Should be loading")
    
    // Wait for completion
    await task.value
    XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
  }
  
  func testLoadItemsHandlesError() async {
    // Given
    let interactor = MockHomeInteractorWithError()
    let viewModel = HomeViewModel(interactor: interactor)
    
    // When
    await viewModel.loadItems()
    
    // Then
    XCTAssertTrue(viewModel.items.isEmpty, "Should have no items on error")
    XCTAssertNotNil(viewModel.errorMessage, "Should have error message")
    XCTAssertFalse(viewModel.isLoading, "Should not be loading after error")
  }
}

// MARK: - Mock Interactors

class MockHomeInteractor: HomeInteractorProtocol {
  func fetchItems() async throws -> [HomeItem] {
    // Simulate network delay
    try await Task.sleep(for: .milliseconds(100))
    
    return [
      HomeItem(id: UUID(), name: "Test 1"),
      HomeItem(id: UUID(), name: "Test 2"),
      HomeItem(id: UUID(), name: "Test 3")
    ]
  }
}

class MockHomeInteractorWithError: HomeInteractorProtocol {
  func fetchItems() async throws -> [HomeItem] {
    // Simulate network delay
    try await Task.sleep(for: .milliseconds(100))
    
    throw NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Test error occurred"])
  }
}
