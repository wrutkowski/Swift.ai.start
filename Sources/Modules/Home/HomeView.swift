import SwiftUI
import Inject

struct HomeView: View {
  @ObserveInjection private var injected
  @ObservedObject var viewModel: HomeViewModel

  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        Text("MVVM SwiftUI Test")
          .font(.title)
          .multilineTextAlignment(.center)
          .padding()

        Button("Load Items") {
          Task {
            await viewModel.loadItems()
          }
        }
        .buttonStyle(.borderedProminent)

        if viewModel.isLoading {
          ProgressView()
            .padding()
        } else {
          List(viewModel.items) { item in
            NavigationLink(value: item) {
              Text(item.name)
                .padding()
            }
          }
        }

        if let errorMessage = viewModel.errorMessage {
          Text(errorMessage)
            .font(.caption)
            .foregroundColor(.red)
            .padding()
        }

        Text("Hot Reload: \(Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle") != nil ? "Enabled" : "Disabled")")
          .font(.caption)
          .foregroundColor(Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle") != nil ? .green : .red)
          .padding(.top)

        Spacer()
      }
      .navigationTitle("Home")
      .navigationDestination(for: HomeItem.self) { item in
        HomeDetailView(item: item)
      }
      .padding()
    }
    .enableInjection()
  }
}

struct HomeDetailView: View {
  let item: HomeItem

  var body: some View {
    VStack {
      Text("Detail for \(item.name)")
        .font(.title)
      Text("This is a detail view using native SwiftUI NavigationStack")
        .font(.body)
        .foregroundColor(.secondary)
    }
    .navigationTitle(item.name)
  }
}

// PreviewProvider for Xcode 16.3 compatibility
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    let interactor = HomeInteractor()
    let viewModel = HomeViewModel(interactor: interactor)
    HomeView(viewModel: viewModel)
  }
}
