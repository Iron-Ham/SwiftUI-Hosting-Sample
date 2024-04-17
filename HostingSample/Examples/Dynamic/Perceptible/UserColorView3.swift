import Perception
import SwiftUI

// Identical to `UserColorView`, but uses a `@Perceptible` for its data model.
// `@Perceptible` behaves identically to `@Observable`, but is back-ported to earlier versions of iOS.
// The only consequence of using `@Perceptible` is the need to wrap your view in a `WithPerceptionTracking`.
struct UserColorView3: View {
  var viewModel: ViewModel

  @MainActor
  private var rectangle: some Shape {
    RoundedRectangle(cornerRadius: 8, style: .continuous)
  }

  var body: some View {
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
