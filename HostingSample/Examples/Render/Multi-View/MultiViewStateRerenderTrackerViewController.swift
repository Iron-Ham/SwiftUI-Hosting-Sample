import SwiftUI

final class MultiViewStateRerenderTrackerViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemGroupedBackground
    title = "Using @State"

    let contentView = HostingView {
      _View()
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
  @State var count = 0
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    let _ = Self._printChanges()
    VStack {
      Text("This text color changes each time it is re-rendered")
        .foregroundStyle(Color.random)

      _SubView()
    }
    .onReceive(timer) { _ in
      count += 1
    }
  }
}

private struct _SubView: View, Equatable {
  var body: some View {
    let _ = Self._printChanges()
    Text("This `subview` `Text` changes color each time it is re-rendered.")
      .foregroundStyle(Color.random)
      .padding()
  }
}
