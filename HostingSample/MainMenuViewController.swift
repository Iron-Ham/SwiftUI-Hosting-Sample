import UIKit

private struct MenuItem: Identifiable, Hashable {
  var title: String
  var subtitle: String

  @IgnoreHashable
  var viewControllerProvider: () -> UIViewController

  var id: String { title }
}

private enum Section: CaseIterable {
  case basic

  var title: String {
    switch self {
    case .basic:
      "Simple examples"
    }
  }

  var examples: [any Example] {
    switch self {
    case .basic:
      SimpleExample.allCases
    }
  }

  var item: MenuItem {
    switch self {
    case .basic:
      MenuItem(
        title: title,
        subtitle: "",
        viewControllerProvider: { UIViewController() }
      )
    }
  }

  static func item(for indexPath: IndexPath) -> MenuItem {
    Section.allCases[indexPath.section].examples[indexPath.row].item
  }
}

private protocol Example: CaseIterable {
  var item: MenuItem { get }
}

private enum SimpleExample: Example {
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
  private typealias CellRegistration = UICollectionView.CellRegistration
  private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration

  private lazy var layout = UICollectionViewCompositionalLayout { _, environment in
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
    listConfiguration.headerMode = .firstItemInSection
    return NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: environment)
  }

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    return collectionView
  }()

  private var dataSource: UICollectionViewDiffableDataSource<Section, MenuItem>!
  private let sections = Section.allCases

  override func loadView() {
    view = collectionView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureDataSource()

    var snapshot = NSDiffableDataSourceSnapshot<Section, MenuItem>()
    snapshot.appendSections(sections)
    dataSource.apply(snapshot, animatingDifferences: false)
    for section in sections {
      var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<MenuItem>()
      let headerItem = section.item
      sectionSnapshot.append([headerItem])
      let items = section.examples.map(\.item)
      sectionSnapshot.append(items, to: headerItem)
      sectionSnapshot.expand([headerItem])
      dataSource.apply(sectionSnapshot, to: section)
    }
  }

  private func configureDataSource() {
    let cellRegistration = CellRegistration<UICollectionViewListCell, MenuItem> { cell, _, item in
      cell.accessories = [.disclosureIndicator()]
      var content = cell.defaultContentConfiguration()
      content.text = item.title
      content.secondaryText = item.subtitle
      content.secondaryTextProperties.color = .secondaryLabel
      cell.contentConfiguration = content
    }

    let headerRegistration = CellRegistration<UICollectionViewListCell, MenuItem> { cell, indexPath, _ in
      let section = self.sections[indexPath.section]
      var content = cell.defaultContentConfiguration()
      content.text = section.title
      cell.contentConfiguration = content
      cell.accessories = [.outlineDisclosure()]
    }

    let dataSource = UICollectionViewDiffableDataSource<Section, MenuItem>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      if indexPath.row == 0 {
        collectionView.dequeueConfiguredReusableCell(
          using: headerRegistration,
          for: indexPath,
          item: item
        )
      } else {
        collectionView.dequeueConfiguredReusableCell(
          using: cellRegistration,
          for: indexPath,
          item: item
        )
      }
    }
    self.dataSource = dataSource
  }
}

extension MainMenuViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    performPrimaryActionForItemAt indexPath: IndexPath
  ) {
    navigationController?.pushViewController(
      Section.item(for: indexPath).viewControllerProvider(),
      animated: true
    )
  }
}


@propertyWrapper
struct IgnoreEquatable<Wrapped>: Equatable {
  var wrappedValue: Wrapped

  static func == (lhs: IgnoreEquatable<Wrapped>, rhs: IgnoreEquatable<Wrapped>) -> Bool {
    true
  }
}

@propertyWrapper
struct IgnoreHashable<Wrapped>: Hashable {
  @IgnoreEquatable var wrappedValue: Wrapped

  func hash(into hasher: inout Hasher) {}
}
