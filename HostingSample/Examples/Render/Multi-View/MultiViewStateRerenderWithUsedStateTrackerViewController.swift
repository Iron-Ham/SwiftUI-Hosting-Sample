import SwiftUI

final class MultiViewStateRerenderWithUsedStateTrackerViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemGroupedBackground
    title = "Using @State: with @State value being used"

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
    let _ = Self._printChanges()
    VStack {
      // This `Text` view will re-draw each time `count` is being used. It will do so because the
      // `@State` has changed in such a way to trigger a re-draw of all child `View`s.
      // Using a `.equatable()` modifier will wrap `Equatable` `View`s into an `EquatableView`,
      // which lets SwiftUI compare a `View` by its `@State` to determine whether or not to re-draw
      // the view.
      Text("This text color changes each time it is re-rendered")
        .foregroundStyle(Color.random)

      // Without `Equatable`, this `_SubView` will be re-created and the new `_SubView` will be
      // drawn. Note that adding `.equatable()` to the view above will not allow it to prevent a
      // re-draw, despite the two views being functionally identical. That is because SwiftUI will
      // walk the hierarchy until it hits a "container" `View` and use the container as the point of
      // comparison. In this case the "container" is `_SubView`, whereas in the previous case the
      // container is `_View`.
      _SubView()
        .equatable()

      Text("This `Text` background cycles through a set of known background colors.")
        .padding()
        .background(colors[count % colors.count])
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
  }
}
