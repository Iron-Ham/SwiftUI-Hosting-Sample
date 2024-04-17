import UIKit
import SwiftUI

private enum Section: CaseIterable {
  case main
}

private struct MenuItem: Hashable {
  let title: LocalizedStringKey
  private(set) var subtitle: LocalizedStringKey?
  private(set) var subitems: [MenuItem] = []
  private(set) var viewController: UIViewController?

  private let identifier = UUID()

  init(
    title: LocalizedStringKey,
    subtitle: LocalizedStringKey? = nil,
    subitems: [MenuItem] = [],
    viewController: @autoclosure () -> UIViewController? = nil
  ) {
    self.title = title
    self.subtitle = subtitle
    self.subitems = subitems
    self.viewController = viewController()
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
    lhs.identifier == rhs.identifier
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

  private lazy var menuItems: [MenuItem] = [
    MenuItem(
      title: "Basic Examples",
      subitems: [
        MenuItem(
          title: "Static SwiftUI Elements",
          subitems: [
            MenuItem(
              title: "Static `SwiftUI` `View` within a `UIView`",
              subtitle: "Use a `HostingView` to nest a `SwiftUI` element within a `UIView`",
              viewController: SimpleHostedViewController()
            )
          ]
        ),
        MenuItem(
          title: "Dynamic SwiftUI Elements",
          subitems: [
            MenuItem(
              title: "Using `@Observable`",
              subtitle: "For iOS 17+ minimum deployments",
              viewController: DynamicSwiftUIViewController()
            ),
            MenuItem(
              title: "Using an `ObservableObject`",
              subtitle: "`ObservableObject` will generally trigger as many `View` updates for a single property changing as there are `Published` properties. This means that things like `FocusState`, dismiss/presents, popovers, and so on will behave erratically. Proceed with extreme care and caution.",
              viewController: DynamicSwiftUIViewObservableObjectController()
            ),
            MenuItem(
              title: "Using `@Perceptible`",
              subtitle: "@Perceptible is a third-party backport of `@Observable` that allows us to deploy `@Observable` behaviors on versions earlier than iOS 17. If you can include a third-party dependency and your deploy-target is currently lower than iOS 17, **this is the recommended approach**.",
              viewController: DynamicSwiftUIPerceptibleViewController()
            )
          ]
        )
      ])
  ]

  override func loadView() {
    view = collectionView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureDataSource()

    self.dataSource.apply(initialSnapshot(), to: .main, animatingDifferences: false)
  }

  private func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<MenuItem> {
    var snapshot = NSDiffableDataSourceSectionSnapshot<MenuItem>()

    func addItems(_ menuItems: [MenuItem], to parent: MenuItem?) {
      snapshot.append(menuItems, to: parent)
      for menuItem in menuItems where !menuItem.subitems.isEmpty {
        addItems(menuItem.subitems, to: menuItem)
      }
    }

    addItems(menuItems, to: nil)
    return snapshot
  }

  private func configureDataSource() {
    let cellRegistration = CellRegistration<UICollectionViewListCell, MenuItem> { cell, _, item in
      cell.accessories = [.disclosureIndicator()]
      cell.contentConfiguration = UIHostingConfiguration {
        VStack(alignment: .leading) {
          Text(item.title)
            .font(.body)
            .foregroundStyle(.primary)
          if let subtitle = item.subtitle {
            Text(subtitle)
              .font(.footnote)
              .foregroundStyle(.secondary)
          }
        }
      }
    }

    let containerCellRegistration = CellRegistration<UICollectionViewListCell, MenuItem> { (cell, _, menuItem) in
      cell.accessories = [.outlineDisclosure(options: UICellAccessory.OutlineDisclosureOptions(style: .header))]
      cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
      cell.contentConfiguration = UIHostingConfiguration {
        Text(menuItem.title)
          .font(.headline)
      }
    }

    let dataSource = UICollectionViewDiffableDataSource<Section, MenuItem>(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, item: MenuItem) -> UICollectionViewCell? in
      if item.subitems.isEmpty {
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
      } else {
        return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: item)
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
    guard let menuItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
    collectionView.deselectItem(at: indexPath, animated: true)

    if let viewController = menuItem.viewController {
      navigationController?.pushViewController(viewController, animated: true)
    }
  }
}
