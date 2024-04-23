import UIKit
import SwiftUI

/// Contains the full set of examples within this project.
/// This view is structured as containing a `UICollectionView`, with a diffable data source and a compositional layout.
/// The cells within this view are inlined SwiftUI via `UIHostingConfiguration`, and the sections are configured to support three
/// levels of nesting: top-level items, sub-sections, and content.
final class MainMenuViewController: UIViewController {
  private typealias CellRegistration = UICollectionView.CellRegistration
  private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration

  private lazy var layout = UICollectionViewCompositionalLayout { _, environment in
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
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
              subtitle: "For iOS 17+ minimum deployments.",
              viewController: DynamicSwiftUIViewController()
            ),
            MenuItem(
              title: "Using an `ObservableObject`",
              subtitle: "`ObservableObject` will generally trigger as many `View` updates for a single property changing as there are `Published` properties. This means that things like `FocusState`, dismiss/presents, popovers, and so on will behave erratically. **Proceed with extreme care and caution**.",
              viewController: DynamicSwiftUIViewObservableObjectController()
            ),
            MenuItem(
              title: "Using `@Perceptible`",
              subtitle: "`@Perceptible` is a third-party backport of `@Observable` that allows us to deploy `@Observable` behaviors on versions earlier than iOS 17. If you can include a third-party dependency and your deploy-target is currently lower than iOS 17, **this is the recommended approach**.",
              viewController: DynamicSwiftUIPerceptibleViewController()
            )
          ]
        )
      ]
    ),

    MenuItem(
      title: "Emoji Views",
      subitems: [
        MenuItem(
          title: "Presentation: inline popover",
          subitems: [
            MenuItem(
              title: "Stock `popover` modifier",
              subtitle: "Use the stock modifier with `presentationCompactAdaptation` to display as a popover on iPhones. Available for iOS 16.4+ deployments.",
              viewController: StockPopoverViewController()
            ),
            MenuItem(
              title: "Custom `popover_backport` modifier",
              subtitle: "Use the `popover_backport` modifier if your deploy target is less than iOS 16.4",
              viewController: PopoverBackportViewController()
            ),
          ]
        ),

        MenuItem(
          title: "Emoji Intensifies: Parallax",
          subitems: [
            MenuItem(
              title: "Animating Emojis, with selection",
              subtitle: "On a device, this appears as a parallax effect. As we don't have data from `CoreMotion` on the simulator, we've mocked values coming from `CoreMotion` as random numbers over a range. The effect on a simulator is an \"intensifies\" animation. More importantly, this demo showcases how we can continue to utilize the `EmojiCollectionViewController`'s filtering even though we don't have access to its `searchController`.",
              viewController: EmojiIntensifiesViewController()
            )
          ]
        )
      ]
    ),

    MenuItem(
      title: "Render Behavior",
      subitems: [
        MenuItem(title: "Basic render behavior", subitems: [
          MenuItem(
            title: "The `@Observable` macro",
            subtitle: "This example contains a `Text` view that sets a random foreground color each render. This example uses the `@Observable` macro instead of `ObservableObject`. It does not re-render the view unnecessarily, as no dependent properties have changed.",
            viewController: ObservableRerenderTrackerViewController()
          ),
          MenuItem(
            title: "The `ObservableObject` protocol.",
            subtitle: "This example contains a `Text` view that sets a random foreground color each render. This example uses the `ObservableObject` protocol instead of `@Observable`. It triggers a full re-render of the view whenever **any** property of the `ObservableObject` changes.",
            viewController: ObservableObjectRerenderTrackerViewController()
          )
        ])
      ]
    )
  ]

  override func loadView() {
    view = collectionView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureDataSource()
    navigationItem.title = "Overview"

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
      cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
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

    let containerCellRegistration = CellRegistration<
      UICollectionViewListCell, MenuItem
    > { (cell, _, menuItem) in
      cell.accessories = [
        .outlineDisclosure(options: UICellAccessory.OutlineDisclosureOptions(style: .header))
      ]
      cell.backgroundConfiguration = UIBackgroundConfiguration.clear()

      let color = self.menuItems.contains(menuItem) ? Color.primary : Color.secondary
      cell.contentConfiguration = UIHostingConfiguration {
        Text(menuItem.title)
          .foregroundStyle(color)
          .font(.headline)
          .padding(.leading, self.menuItems.contains(menuItem) ? 0 : 8)
      }
    }

    let dataSource = UICollectionViewDiffableDataSource<Section, MenuItem>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      if item.subitems.isEmpty {
        return collectionView.dequeueConfiguredReusableCell(
          using: cellRegistration,
          for: indexPath,
          item: item
        )
      } else {
        return collectionView.dequeueConfiguredReusableCell(
          using: containerCellRegistration,
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
    guard let menuItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
    collectionView.deselectItem(at: indexPath, animated: true)

    if let viewController = menuItem.viewController {
      navigationController?.pushViewController(viewController, animated: true)
    }
  }
}

private extension MainMenuViewController {
  enum Section: CaseIterable {
    case main
  }

  struct MenuItem: Hashable {
    let title: LocalizedStringKey
    private(set) var subtitle: LocalizedStringKey?
    private(set) var subitems: [MenuItem] = []
    private(set) var viewController: UIViewController?

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
      hasher.combine(title.stringKey)
    }
  }
}

private extension LocalizedStringKey {
  var stringKey: String? {
    Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
  }
}
