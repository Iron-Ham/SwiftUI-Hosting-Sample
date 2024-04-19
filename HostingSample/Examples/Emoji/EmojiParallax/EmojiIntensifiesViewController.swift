import UIKit

final class EmojiIntensifiesViewController: UIViewController {
  var viewModel = EmojiParallaxView.ViewModel(emoji: Emoji.all[0])

  private(set) lazy var searchController: UISearchController = {
    let controller = UISearchController(searchResultsController: nil)
    controller.searchResultsUpdater = self
    controller.searchBar.placeholder = "Search"
    controller.searchBar.searchTextField.smartQuotesType = .no
    controller.searchBar.autocapitalizationType = .none
    controller.obscuresBackgroundDuringPresentation = false
    controller.hidesNavigationBarDuringPresentation = false
    return controller
  }()

  lazy var parallaxHostingView = HostingView {
    EmojiParallaxView(viewModel: viewModel)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGroupedBackground
    navigationItem.searchController = searchController
#if targetEnvironment(simulator)
    navigationItem.title = "Emoji Intensifies"
#else
    navigationItem.title = "Emoji Parallax"
#endif

    parallaxHostingView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(parallaxHostingView)
    NSLayoutConstraint.activate([
      parallaxHostingView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      parallaxHostingView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      parallaxHostingView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      parallaxHostingView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
    ])
  }
}

extension EmojiIntensifiesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    viewModel.searchText = searchController.searchBar.text ?? ""
  }
}
