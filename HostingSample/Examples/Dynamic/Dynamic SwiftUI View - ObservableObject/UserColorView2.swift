import SwiftUI

// Identical to `UserColorView`, but uses an ObservableObject as its data model.
// The consequence of this is that each update to the observable object triggers multiple times.
// Set a `Self._printChanges()` in the body variable – or set it in a breakpoint – to view details.
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
