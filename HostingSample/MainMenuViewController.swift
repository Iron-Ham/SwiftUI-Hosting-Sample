import UIKit

private struct MenuItem {
  var title: String
  var subtitle: String
  var viewControllerProvider: () -> UIViewController
}

private enum Examples: CaseIterable {
  case simpleHostedSwiftUIViews
  case dynamicSwiftUIViewController
  case dynamicObservableObject
  case dynamicPerception

  var item: MenuItem {
    switch self {
    case .simpleHostedSwiftUIViews:
      return MenuItem(
        title: "Static SwiftUI View within a UIView",
        subtitle: "Use a HostingView to nest a SwiftUI element within a UIView",
        viewControllerProvider: { SimpleHostedViewController() }
      )
    case .dynamicSwiftUIViewController:
      return MenuItem(
        title: "Dynamic SwiftUI View within a UIViewController",
        subtitle: "Uses the @Observable macro to minimize view updates",
        viewControllerProvider: { DynamicSwiftUIViewController() }
      )
    case .dynamicObservableObject:
      return MenuItem(
        title: "Dynamic SwiftUI View within a UIViewController",
        subtitle: "Uses an ObservableObject",
        viewControllerProvider: { DynamicSwiftUIViewObservableObjectController() }
      )
    case .dynamicPerception:
      return MenuItem(
        title: "Dynamic SwiftUI View within a UIViewController",
        subtitle: "Uses @Perceptible, a third-party backport of @Observable",
        viewControllerProvider: { DynamicSwiftUIPerceptibleViewController() }
      )
    }
  }
}

final class MainMenuViewController: UIViewController {
  private typealias Registration = UICollectionView.CellRegistration

  private lazy var layout = UICollectionViewCompositionalLayout { _, environment in
    let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
    return NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: environment)
  }

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }()

  private var cellRegistration: Registration<UICollectionViewListCell, MenuItem> = {
    .init { cell, _, item in
      cell.accessories = [.disclosureIndicator()]
      var content = cell.defaultContentConfiguration()
      content.text = item.title
      content.secondaryText = item.subtitle
      content.secondaryTextProperties.color = .secondaryLabel
      cell.contentConfiguration = content
    }
  }()

  private let examples = Examples.allCases.map(\.item)

  override func loadView() {
    view = collectionView
  }
}

extension MainMenuViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    examples.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    collectionView.dequeueConfiguredReusableCell(
      using: cellRegistration,
      for: indexPath,
      item: examples[indexPath.item]
    )
  }
}

extension MainMenuViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    performPrimaryActionForItemAt indexPath: IndexPath
  ) {
    navigationController?.pushViewController(
      examples[indexPath.item].viewControllerProvider(),
      animated: true
    )
  }
}
