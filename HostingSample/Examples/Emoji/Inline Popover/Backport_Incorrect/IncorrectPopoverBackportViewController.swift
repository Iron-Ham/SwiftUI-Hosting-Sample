import SwiftUI

final class IncorrectPopoverBackportViewController: UIViewController {
  private let viewModel = _PopoverBackportView.ViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemGroupedBackground

    let contentView = HostingView {
      _PopoverBackportView(viewModel: self.viewModel)
    }

    let stackView = UIStackView(arrangedSubviews: [UIView(), contentView, UIView()])
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


private struct _PopoverBackportView: View {
  @StateObject var viewModel: ViewModel

  var body: some View {
    EmojiBadgeView(
      showEmojiSheet: $viewModel.showEmojiSheet,
      selectedEmoji: $viewModel.selectedEmoji
    )
    .accessibilityAddTraits(.isButton)
    .onTapGesture {
      viewModel.showEmojiSheet.toggle()
    }
    .popover_backport(isPresented: $viewModel.showEmojiSheet) {
      EmojiPopoverCollectionView(selectedEmoji: $viewModel.selectedEmoji)
        .frame(
          minWidth: 200,
          idealWidth: 400,
          maxWidth: 400,
          minHeight: 200,
          idealHeight: 400,
          maxHeight: 400
        )
    }
  }
}

private extension _PopoverBackportView {
  @MainActor
  final class ViewModel: ObservableObject {
    @Published var showEmojiSheet: Bool = false
    @Published var selectedEmoji: Emoji?
  }
}

#Preview {
  PopoverBackportView()
}
