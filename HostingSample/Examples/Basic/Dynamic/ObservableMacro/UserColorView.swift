import SwiftUI

/// The `UserColorView` is identical to its siblings in the `Dynamic` section. This implementation differentiates itself in that it
/// uses an `@Observable` model as opposed to another technique.
struct UserColorView: View {
  @State var viewModel: ViewModel

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

extension UserColorView {
  @Observable class ViewModel {
    var selectedIconName: String
    var preferredColor: Color

    init(selectedIconName: String = "questionmark", preferredColor: Color = .blue) {
      self.selectedIconName = selectedIconName
      self.preferredColor = preferredColor
    }
  }
}

#Preview {
  UserColorView(viewModel: UserColorView.ViewModel())
}
