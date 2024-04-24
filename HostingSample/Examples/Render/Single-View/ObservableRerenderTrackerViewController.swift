import SwiftUI

final class ObservableRerenderTrackerViewController: UIViewController {
  private var viewModel = _View.ViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemGroupedBackground
    title = "The @Observable macro"

    let contentView = HostingView {
      _View(viewModel: viewModel)
    }

    let explanationView = HostingView {
      Text("Both the view above and this view are set to change color each time they are re-rendered. The mechanism by which this render is triggered is a `Timer`: Every second, an unused `count` variable is incremented.")
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
  @State var viewModel: ViewModel

  var body: some View {
    let _ = Self._printChanges()
    Text("This text color changes each time it is re-rendered")
      .foregroundStyle(Color.random)
  }
}

private extension _View {
  @Observable final class ViewModel {
    var someBoolean = false
    @ObservationIgnored
    var timer: Timer?

    init() {
      timer = Timer.scheduledTimer(
        withTimeInterval: 1,
        repeats: true
      ) { _ in
        self.someBoolean = false
      }
    }
  }
}
