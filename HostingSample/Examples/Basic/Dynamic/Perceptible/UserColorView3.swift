import Perception
import SwiftUI

/// The `UserColorView3` is identical to its siblings in the `Dynamic` section. This implementation differentiates itself in that it
/// uses a `@Perceptible` model as opposed to another technique.
struct UserColorView3: View {
  var viewModel: ViewModel

  @MainActor
  private var rectangle: some Shape {
    RoundedRectangle(cornerRadius: 8, style: .continuous)
  }

  var body: some View {
    // As this is using a @Perceptible model, we must use a `WithPerceptionTracking` block in order
    // to observe on changes within the model.
    WithPerceptionTracking {
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
}

extension UserColorView3 {
  // Declaring a `@Perceptible` is identical to declaring an `@Observable`.
  @Perceptible
  class ViewModel {
    var selectedIconName: String
    var preferredColor: Color

    init(selectedIconName: String = "questionmark", preferredColor: Color = .blue) {
      self.selectedIconName = selectedIconName
      self.preferredColor = preferredColor
    }
  }
}

#Preview {
  UserColorView3(viewModel: UserColorView3.ViewModel())
}
