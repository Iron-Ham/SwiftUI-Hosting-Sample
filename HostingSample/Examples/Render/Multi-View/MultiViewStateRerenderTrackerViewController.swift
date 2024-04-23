import SwiftUI

final class MultiViewStateRerenderTrackerViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemGroupedBackground

    let contentView = HostingView {
      _View()
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

private struct _View: View {
  @State var count = 0
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    let _ = Self._printChanges()
    VStack {
      Text("This text color changes each time it is re-rendered")
        .foregroundStyle(Color(
          red: .random(in: 0...1),
          green: .random(in: 0...1),
          blue: .random(in: 0...1)
        ))

      _SubView()
    }
    .onReceive(timer) { input in
      count += 1
    }
  }
}

private struct _SubView: View, Equatable {
  var body: some View {
    let _ = Self._printChanges()
    Text("This `subview` `Text` changes color each time it is re-rendered.")
      .foregroundStyle(Color(
        red: .random(in: 0...1),
        green: .random(in: 0...1),
        blue: .random(in: 0...1)
      ))
      .padding()
  }
}
