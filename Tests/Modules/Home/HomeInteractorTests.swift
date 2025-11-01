import XCTest
@testable import SwiftCatalyst

final class HomeInteractorTests: XCTestCase {
  func testFetchItems() async throws {
    // Given
    let interactor = HomeInteractor()

    // When
    let items = try await interactor.fetchItems()

    // Then
    XCTAssertFalse(items.isEmpty, "Items should not be empty")
    XCTAssertEqual(items.count, 5, "Should return 5 items")
  }

  func testFetchItemsReturnsExpectedData() async throws {
    // Given
    let interactor = HomeInteractor()

    // When
    let items = try await interactor.fetchItems()

    // Then
    XCTAssertTrue(items.contains { $0.name == "Swift" }, "Should contain Swift")
    XCTAssertTrue(items.contains { $0.name == "UIKit" }, "Should contain UIKit")
    XCTAssertTrue(items.contains { $0.name == "SwiftUI" }, "Should contain SwiftUI")
    XCTAssertTrue(items.contains { $0.name == "Combine" }, "Should contain Combine")
    XCTAssertTrue(items.contains { $0.name == "Concurrency" }, "Should contain Concurrency")
  }

  func testFetchItemsReturnsUniqueIds() async throws {
    // Given
    let interactor = HomeInteractor()

    // When
    let items = try await interactor.fetchItems()

    // Then
    let ids = items.map { $0.id }
    let uniqueIds = Set(ids)
    XCTAssertEqual(ids.count, uniqueIds.count, "All IDs should be unique")
  }
}
