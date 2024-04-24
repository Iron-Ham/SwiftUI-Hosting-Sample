import SwiftUI

/// The `UserColorView2` is identical to its siblings in the `Dynamic` section. This implementation differentiates itself in that it
/// uses an `ObservableObject` as opposed to another technique.
struct UserColorView2: View {
  @StateObject var viewModel: ViewModel

  @MainActor
  private var rectangle: some Shape {
    RoundedRectangle(cornerRadius: 8, style: .continuous)
  }

  var body: some View {
    VStack {
      Text("Selected Icon")
        .font(.footnote)
        .foregroundStyle(.secondary)

      Image(systemName: viewModel.selectedIconName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .font(.body)
        .foregroundStyle(viewModel.preferredColor)
        .frame(width: 16, height: 16)
        .padding()
        .background(viewModel.preferredColor.opacity(0.1))
        .clipShape(rectangle)
        .overlay(rectangle.stroke(viewModel.preferredColor.opacity(0.2)))
    }
  }
}

extension UserColorView2 {
  class ViewModel: ObservableObject {
    @Published var selectedIconName: String
    @Published var preferredColor: Color

    init(selectedIconName: String = "questionmark", preferredColor: Color = .blue) {
      self.selectedIconName = selectedIconName
      self.preferredColor = preferredColor
    }
  }
}

#Preview {
  UserColorView2(viewModel: UserColorView2.ViewModel())
}
