import UIKit

/// Contains a `PopoverBackportView`.
final class PopoverBackportViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemGroupedBackground

    let contentView = HostingView {
      PopoverBackportView()
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
