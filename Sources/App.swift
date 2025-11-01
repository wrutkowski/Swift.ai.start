import SwiftUI
import Inject

@main
struct SwiftCatalystApp: App {
  @ObserveInjection var inject

  init() {
    #if DEBUG
    // Try to load injection bundle from app resources
    if let path = Bundle.main.path(forResource: "iOSInjection", ofType: "bundle") {
      Bundle(path: path)?.load()
    }
    #endif
  }

  var body: some Scene {
    WindowGroup {
      HomeView(viewModel: HomeViewModel(interactor: HomeInteractor()))
        .enableInjection()
    }
  }
}
