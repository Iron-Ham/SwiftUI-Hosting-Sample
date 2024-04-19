import UIKit

final class EmojiIntensifiesViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemGroupedBackground

    let contentView = HostingView {
      EmojiParallaxView(emoji: Emoji.all[0])
    }

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
