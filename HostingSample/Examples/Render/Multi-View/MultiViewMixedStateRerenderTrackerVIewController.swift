import SwiftUI

final class MultiViewMixedStateRerenderTrackerViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemGroupedBackground
    title = "Using @State and @Observable"

    let contentView = HostingView {
      _View()
    }

    let explanationView = HostingView {
      Text("Both the view above and this view are set to change color each time they are re-rendered. The mechanism by which this render is triggered is a `Timer`: Every second, a `count` variable is incremented. This `count` variable is in use exclusively by the `Text` which reads \"This `Text` background cycles through a set of known background colors.\"")
        .foregroundStyle(
          [Color.blue, .brown, .red, .green, .purple, .orange].shuffled().first ?? .black
        )
    }

    let stackView = UIStackView(arrangedSubviews: [UIView(), contentView, UIView(), explanationView, UIView()])
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
    ])
  }
}

private struct _View: View {
  @State var count = 0
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  private let colors: [Color] = [.blue, .red, .green, .purple, .yellow, .orange, .cyan]

  var body: some View {
    VStack {
      Text("This text color changes each time it is re-rendered")
        .foregroundStyle(Color.random)

      ObservablePopoverView()

      Text("This `Text` background cycles through a set of known background colors.")
        .padding()
        .background(colors[count % colors.count])
    }
    .onReceive(timer) { _ in
      count += 1
    }
  }
}

private struct ObservablePopoverView: View {
  @Observable class ViewModel {
    var showEmojiSheet: Bool = false
    var selectedEmoji: Emoji?
  }

  @State var viewModel = ViewModel()

  var body: some View {
    let _ = Self._printChanges()
    EmojiBadgeView(showEmojiSheet: $viewModel.showEmojiSheet, selectedEmoji: $viewModel.selectedEmoji)
      .accessibilityAddTraits(.isButton)
      .onTapGesture { viewModel.showEmojiSheet.toggle() }
      .popover(isPresented: $viewModel.showEmojiSheet) {
        EmojiPopoverCollectionView(selectedEmoji: $viewModel.selectedEmoji)
          .frame(
            minWidth: 200,
            idealWidth: 400,
            maxWidth: 400,
            minHeight: 200,
            idealHeight: 400,
            maxHeight: 400
          )
          .presentationCompactAdaptation(.popover)
      }
      .padding()
      .background(Color.random)
  }
}

private struct _SubView: View, Equatable {
  var body: some View {
    let _ = Self._printChanges()
    Text("This `subview` `Text` changes color each time it is re-rendered.")
      .foregroundStyle(Color.random)
  }
}
