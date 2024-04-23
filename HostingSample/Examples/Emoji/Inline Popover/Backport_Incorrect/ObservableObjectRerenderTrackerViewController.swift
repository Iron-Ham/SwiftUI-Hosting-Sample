import SwiftUI

final class ObservableObjectRerenderTrackerViewController: UIViewController {
  private var viewModel = _PopoverBackportView.ViewModel()

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
    let _ = Self._printChanges()
    VStack {
      Text("This text color changes each time it is re-rendered")
        .foregroundStyle(Color(
          red: .random(in: 0...1),
          green: .random(in: 0...1),
          blue: .random(in: 0...1)
        ))
    }
  }
}

private extension _PopoverBackportView {
  final class ViewModel: ObservableObject {
    @Published var showEmojiSheet: Bool = false
    @Published var selectedEmoji: Emoji?
    var timer: Timer?

    init(
      showEmojiSheet: Bool = false,
      selectedEmoji: Emoji? = nil
    ) {
      self.showEmojiSheet = showEmojiSheet
      self.selectedEmoji = selectedEmoji
      timer = Timer.scheduledTimer(
        withTimeInterval: 1,
        repeats: true
      ) { _ in
        self.showEmojiSheet = false
      }
    }
  }
}