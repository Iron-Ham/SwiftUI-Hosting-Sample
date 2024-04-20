import SnapKit
import SwiftUI
import UIKit

protocol EmojiCollectionDelegate: AnyObject {
  func didSelect(_ viewController: EmojiCollectionViewController, emoji: Emoji)
}

final class EmojiCollectionViewController: UIViewController, UISearchResultsUpdating {
  private lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    view.backgroundColor = .clear
    return view
  }()

  private var emojiDataSource: UICollectionViewDiffableDataSource<Section, Emoji.ID>!
  private var selectedEmoji = ContentView.ViewModel(selectedViewModelId: nil)
  weak var delegate: EmojiCollectionDelegate?

  private var snapshot: NSDiffableDataSourceSnapshot<Section, Emoji.ID> {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Emoji.ID>()
    if !emojiSearchText.isEmpty {
      snapshot.appendSections([.search])
      categories.forEach { category in
        snapshot.appendItems(
          category.search(query: emojiSearchText).map(\.id),
          toSection: .search
        )
      }
    } else {
      snapshot.appendSections(categories.map(Section.category))
      categories.forEach { category in
        snapshot.appendItems(
          category.allAllowableEmojis.map(\.id),
          toSection: .category(category)
        )
      }
    }
    return snapshot
  }

  private var emojiSearchText = "" {
    didSet {
      if (oldValue.isEmpty && !emojiSearchText.isEmpty) || (!oldValue.isEmpty && emojiSearchText.isEmpty) {
        activeCategory = .smileys
      }
      applyUpdate()
    }
  }

  private let categories = EmojiCategory.allCases
  private var activeCategory: EmojiCategory? {
    didSet {
      let category = activeCategory ?? .smileys
      segmentedControl.selectedSegmentIndex = categories.firstIndex(of: category) ?? 0
    }
  }

  private let emojiMap = [Emoji.ID: Emoji](
    Emoji.all.map { ($0.id, $0) },
    uniquingKeysWith: { id, _ in return id }
  )

  private struct CacheKey: Hashable {
    let indexPath: IndexPath?
    let searchTerm: String
  }

  private var cache: [CacheKey: [Emoji]] = [:]

  private lazy var searchController: UISearchController = {
    let controller = UISearchController(searchResultsController: nil)
    controller.searchResultsUpdater = self
    controller.searchBar.placeholder = "Search"
    controller.searchBar.searchTextField.smartQuotesType = .no
    controller.searchBar.autocapitalizationType = .none
    controller.obscuresBackgroundDuringPresentation = false
    controller.hidesNavigationBarDuringPresentation = false
    return controller
  }()

  var isActivelyScrolling = false {
    didSet {
      segmentedControl.isUserInteractionEnabled = !isActivelyScrolling
    }
  }

  private lazy var segmentedControl = UISegmentedControl(
    frame: .zero,
    actions: categories.enumerated().map { index, category in
      let image: UIImage? = category.image?.withTintColor(
        UIColor(Color.secondary),
        renderingMode: .alwaysOriginal // `UIAction` will ignore template tints and apply its own.
      )
      // A note: the `UISegmentedControl(frame:actions:) initializer displays the `UIAction`s in a
      // `UIMenu` under the hood. There is no support for `UIDeferredMenuElement` within this
      // initializer, meaning that the `selectedImage` argument of a `UIAction` will not be respected.
      // A UIMenu cannot dynamically change its elements unless those elements are `UIDeferredMenuElement`.
      return UIAction(
        image: image,
        discoverabilityTitle: category.name
      ) { [weak self] _ in
        let indexPath = IndexPath(item: 0, section: index)
        guard let self,
              self.activeCategory != category,
              self.emojiSearchText.isEmpty,
              !self.collectionView.indexPathsForVisibleItems.contains(indexPath)
        else { return }
        self.isActivelyScrolling = true
        self.activeCategory = category
        self.collectionView.scrollToItem(
          at: indexPath,
          at: .top,
          animated: true
        )
      }
    }
  )

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.contentInset = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: view.bounds.height - segmentedControl.frame.origin.y + 8,
      right: 0
    )
  }
  init(embedSearchBarIntoNavigationTitleView: Bool = true) {
    super.init(nibName: nil, bundle: nil)
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }

    view.addSubview(segmentedControl)
    segmentedControl.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.bottom.equalToSuperview().inset(8)
      make.top.equalTo(collectionView.snp.bottom)
    }

    segmentedControl.selectedSegmentTintColor = UIColor(Color.blue.opacity(0.1))
    segmentedControl.selectedSegmentIndex = 0

    collectionView.delegate = self
    definesPresentationContext = true
    if embedSearchBarIntoNavigationTitleView {
      navigationItem.titleView = searchController.searchBar
    }
    configureDataSource()
  }

  func update(selection: Emoji?) {
    guard self.selectedEmoji.selectedViewModelId != selection?.id else { return }
    self.selectedEmoji.selectedViewModelId = selection?.id
    applyUpdate()
  }

  func update(searchText: String) {
    guard emojiSearchText != searchText else { return }
    emojiSearchText = searchText
  }

  private func applyUpdate() {
    emojiDataSource.apply(snapshot)
  }

  func updateSearchResults(for searchController: UISearchController) {
    emojiSearchText = searchController.searchBar.text ?? ""
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension EmojiCollectionViewController {
  private func createLayout() -> UICollectionViewLayout {
    UICollectionViewCompositionalLayout { _, _ in
      let height = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize + 8
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalHeight(1),
        heightDimension: .fractionalHeight(1)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .estimated(height)
      )
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      group.interItemSpacing = .flexible(8)
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 24, bottom: 8, trailing: 24)

      let headerFooterSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44)
      )
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerFooterSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )
      section.boundarySupplementaryItems = [sectionHeader]
      return section
    }
  }

  private func configureDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<
      UICollectionViewCell, Emoji
    > { cell, _, viewModel in
      cell.contentConfiguration = UIHostingConfiguration { [weak self] in
        if let self {
          ContentView(
            viewModel: selectedEmoji,
            emoji: viewModel,
            onSelect: { emoji in
              self.selectedEmoji.selectedViewModelId = emoji.id
              self.delegate?.didSelect(self, emoji: emoji)
            }
          )
        } else {
          EmptyView()
        }
      }
    }

    let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(
      elementKind: UICollectionView.elementKindSectionHeader
    ) { supplementaryView, _, indexPath in
      if self.emojiSearchText.isEmpty {
        supplementaryView.label.text = self.categories[indexPath.section].name
      } else {
        supplementaryView.label.text = "Results"
      }
    }

    let dataSource = UICollectionViewDiffableDataSource<Section, String>(
      collectionView: self.collectionView
    ) { [weak self] collectionView, indexPath, item in
      guard let self,
            let emoji = self.emojiMap[item]
      else { return UICollectionViewCell() }
      return collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: emoji
      )
    }

    dataSource.supplementaryViewProvider = { view, _, index in
      view.dequeueConfiguredReusableSupplementary(
        using: headerRegistration,
        for: index
      )
    }
    emojiDataSource = dataSource
    // Apply initial data
    emojiDataSource.apply(snapshot, animatingDifferences: false)
  }
}

private extension EmojiCollectionViewController {
  private enum Section: Sendable, Hashable, Identifiable {
    case category(EmojiCategory), search

    var id: String {
      switch self {
      case .category(let emojiCategory):
        emojiCategory.id
      case .search:
        "Search"
      }
    }
  }
}

extension EmojiCollectionViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplaySupplementaryView view: UICollectionReusableView,
    forElementKind elementKind: String,
    at indexPath: IndexPath
  ) {
    guard let visibleIndex = collectionView.indexPathsForVisibleItems.sorted().first, !isActivelyScrolling else { return }
    activeCategory = categories[visibleIndex.section]
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didEndDisplayingSupplementaryView view: UICollectionReusableView,
    forElementOfKind elementKind: String,
    at indexPath: IndexPath
  ) {
    guard let visibleIndex = collectionView.indexPathsForVisibleItems.sorted().first, !isActivelyScrolling else { return }
    activeCategory = categories[visibleIndex.section]
  }

  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    isActivelyScrolling = false
  }
}
private extension EmojiCategory {
  func search(query: String) -> [Emoji] {
    if query.isEmpty {
      allAllowableEmojis
    } else {
      allAllowableEmojis
        .filter { emoji in
          emoji.alias.localizedCaseInsensitiveContains(query)
        }
    }
  }

  var allAllowableEmojis: [Emoji] {
    allEmojis
  }

  var image: UIImage? {
    switch self {
    case .smileys:
      UIImage(systemName: "face.smiling")
    case .people:
      UIImage(systemName: "hand.thumbsup")
    case .animals:
      UIImage(systemName: "tortoise")
    case .food:
      UIImage(systemName: "carrot")
    case .travel:
      UIImage(systemName: "car")
    case .activities:
      UIImage(systemName: "tennisball")
    case .objects:
      UIImage(systemName: "desktopcomputer")
    case .symbols:
      UIImage(systemName: "heart")
    case .flags:
      UIImage(systemName: "flag")
    }
  }
}

private class TitleSupplementaryView: UICollectionReusableView {
  let label = UILabel()
  static let reuseIdentifier = "title-supplementary-reuse-identifier"

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(label)
    label.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalToSuperview().inset(8)
    }
    label.adjustsFontForContentSizeCategory = true
    label.font = .preferredFont(forTextStyle: .footnote)
    label.textColor = .tertiaryLabel
  }
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
}

private struct ContentView: View {
  @State var viewModel: ViewModel

  let emoji: Emoji
  let onSelect: (Emoji) -> Void

  var body: some View {
    EmojiView(emoji: emoji, usesBodyScaling: false)
      .padding(4)
      .onTapGesture {
        viewModel.selectedViewModelId = emoji.id
        onSelect(emoji)
      }
      .background(emoji.id == viewModel.selectedViewModelId ? Color.blue.opacity(0.1) : .clear)
      .clipShape(RoundedRectangle(
        cornerRadius: 6,
        style: .continuous
      ))
  }
}

extension ContentView {
  @Observable final class ViewModel {
    var selectedViewModelId: Emoji.ID?

    init(selectedViewModelId: Emoji.ID?) {
      self.selectedViewModelId = selectedViewModelId
    }
  }
}
