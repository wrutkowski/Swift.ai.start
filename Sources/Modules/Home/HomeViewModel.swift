import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
  @Published private(set) var items: [HomeItem] = []
  @Published private(set) var isLoading: Bool = false
  @Published private(set) var errorMessage: String?
  @Published var selectedItem: HomeItem?

  private let interactor: HomeInteractorProtocol

  init(interactor: HomeInteractorProtocol) {
    self.interactor = interactor
  }

  @MainActor
  func loadItems() async {
    isLoading = true
    defer { isLoading = false }
    errorMessage = nil
    do {
      items = try await interactor.fetchItems()
    } catch {
      errorMessage = "Failed to load items: \(error.localizedDescription)"
    }
  }
}
