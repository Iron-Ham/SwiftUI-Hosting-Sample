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
            )
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
        MenuItem(title: "Single-view behavior", subitems: [
          MenuItem(
            title: "The `@Observable` macro",
            subtitle: "This example contains a `Text` view that sets a random foreground color each render. This example uses the `@Observable` macro instead of `ObservableObject`. It does not re-render the view unnecessarily, as no dependent properties have changed.",
            viewController: ObservableRerenderTrackerViewController()
          ),
          MenuItem(
            title: "The `ObservableObject` protocol.",
            subtitle: "This example contains a `Text` view that sets a random foreground color each render. This example uses the `ObservableObject` protocol instead of `@Observable`. It triggers a full re-render of the view whenever **any** property of the `ObservableObject` changes.",
            viewController: ObservableObjectRerenderTrackerViewController()
          ),
          MenuItem(
            title: "Using `@State`",
            subtitle: "This example contains a `Text` view that sets a random foreground color each render. This example uses `@State` to store an unused integer.",
            viewController: StateRerenderTrackerViewController()
          )
        ]),

        MenuItem(
          title: "Multi-view behavior",
          subitems: [
            MenuItem(
              title: "Using `@State`",
              subtitle: "This example is an extension of the Single-view `@State` example. It contains a nearly identical `_SubView` which is _not_ `Equatable` and does not use the `.equatable()` View modifier. Given that the `@State` value is not in use, it never re-renders its children.",
              viewController: MultiViewStateRerenderTrackerViewController()
            ),
            MenuItem(
              title: "Using `@State`: with `@State` value being used",
              subtitle: "Identical to the previous example, but with two additions: (1) It marks the `_SubView` `.equatable()`. (2) It uses an additional view which utilizes the `count` `@State` property. As a result, the direct child views of this view are re-rendered each time that `State` changes, whereas the `_SubView` is only rendered once.",
              viewController: MultiViewStateRerenderWithUsedStateTrackerViewController()
            ),
            MenuItem(
              title: "Using `@State` and `@Observable`",
              subtitle: "Similar to the previous example, but uses a `ObservablePopoverView` in place of the `_SubView`, as the `ObservablePopoverView` uses an `@Observable`. **NOTE:** the `ObservablePopoverView` is re-rendered each time, but the `@Observable` `ViewModel` is copied by reference to each new `ObservablePopoverView`. This ensures no loss of state between re-renders, but may result in unintended behavior as the `View` continually re-renders. Additionally, rendering complex `View`s more than necessary can be a huge cost to performance. **In order to prevent a re-render of `View`s, `@State` must be tightly scoped, constituent subviews must be `Equatable`, and they must additionally use the `.equatable()` modifier.**",
              viewController: MultiViewMixedStateRerenderTrackerViewController()
            ),
            MenuItem(
              title: "Using `@State` and `@Observable`: with `Equatable`",
              subtitle: "Identical to the previous example, but the `ObservablePopoverView` has been given `Equatable` conformance and uses the `.equatable()` modifier. As a result, the `ObservablePopoverView` does not re-render unless its dependencies change.",
              viewController: MultiViewMixedStateWithEquatableRerenderTrackerViewController()
            )
          ]
        )
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
        }.id(item.title.stringKey ?? "")
        // READER'S NOTE: Why is there a `.id` modifier on this SwiftUI `View`?
        //
        // Every SwiftUI `View` needs to have an identifier so the layout system can diff changes in
        // our layout. This happens automatically for statically defined `View`s, but this is not
        // possible for arbitrarily sized collections. This is why a `ForEach` block requires either
        // an `id` key path, or a collection of `Identifiable` models to populate a `View` id.
        //
        // When we use a `UIHostingConfiguration`, the SwiftUI View does not know it's hosted in a
        // collection or table view. When a cell is reused, there's no indication to the `View` that
        // it is now displaying new and unrelated data. For this reason, we must assign an `id` to
        // the `View`.
        //
        // In this instance, we don't have any information that cannot be instantly re-bound, but
        // for asynchronously accessed/downloaded info this is especially important, otherwise we
        // may have the previous content "flash" on-screen for a brief moment before being re-set.
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
          .id(menuItem.title.stringKey ?? "")
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
