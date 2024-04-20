import UIKit
import SwiftUI

/// Showcases static SwiftUI content within a `UIView`.
/// In this instance, we showcase a SwiftUI `Label` and contrast it to a `UIKit` `UIImageView` and `UILabel` within a
/// `UIStackView`.
final class SimpleHostedViewController: UIViewController {
  override func viewDidLoad() {
    title = "Static SwiftUI View within a UIView"
    view.backgroundColor = .systemBackground

    let contentView = ContentView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contentView)
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
    ])
  }
}

private final class ContentView: UIView {
  init() {
    super.init(frame: .zero)

    // Full set of SwiftUI Configuration
    let hostingView = HostingView {
      VStack {
        Label {
          Text("A SwiftUI `Label` View, with icon. As this is a default SwiftUI `Label` View, it automatically centers the icon in the center of the first line of text. This behavior is pretty handy.")
        } icon: {
          Image(systemName: "scribble.variable")
            .foregroundStyle(.blue)
        }
      }
    }

    // Roughly equivalent UIKit version.
    // UIKit does not parse markdown by default, nor does it have easy support for first-line center-aligned
    // images in `UIStackView`s.
    let image = UIImage(
      systemName: "scribble.variable",
      withConfiguration: UIImage.SymbolConfiguration(textStyle: .body)
    )
    let icon = UIImageView(image: image)
    icon.tintColor = UIColor(Color.blue) // Note that UIColor.blue is different from Color.blue
    icon.contentMode = .scaleAspectFit

    let label = UILabel()
    label.numberOfLines = 0
    label.text = "A UIKit `UILabel` UIView. As this is a default `UILabel`, it doesn't have support for icons in a normal `text` property, and has no knowledge of an icon in its hierarchy. Any adjustment of the icon positioning would have to occur within the parent view, which in this case is a `UIStackView`. This is a more complex consideration in UIKit, and I'll leave that as an exercise to the reader."

    let internalStackView = UIStackView(arrangedSubviews: [icon, label])
    internalStackView.axis = .horizontal
    internalStackView.spacing = 8
    internalStackView.distribution = .fill

    let contentStackView = UIStackView(arrangedSubviews: [
      hostingView,
      UIView(), // A spacer, just to prevent stretching across the entire UIViewController
      internalStackView,
      UIView() // A spacer, just to prevent stretching across the entire UIViewController
    ])
    contentStackView.axis = .vertical
    contentStackView.spacing = 16
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      contentStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      contentStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      contentStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
