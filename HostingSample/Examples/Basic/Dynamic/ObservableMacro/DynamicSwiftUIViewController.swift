import UIKit
import SwiftUI

// In this example, we showcase using a `HostingView` for SwiftUI content that is dynamic by nature.
final class DynamicSwiftUIViewController: UIViewController {
  var viewModel: UserColorView.ViewModel
  private let colorProvider = ColorPickerDataProvider()
  private let iconProvider = IconPickerDataProvider()

  private lazy var colorPicker: UIPickerView = {
    let colorPicker = UIPickerView()
    colorPicker.delegate = colorProvider
    colorPicker.dataSource = colorProvider
    return colorPicker
  }()

  private lazy var iconPicker: UIPickerView = {
    let iconPicker = UIPickerView()
    iconPicker.delegate = iconProvider
    iconPicker.dataSource = iconProvider
    return iconPicker
  }()

  private lazy var colorView: HostingView<UserColorView> = HostingView {
    UserColorView(viewModel: viewModel)
  }

  init(viewModel: UserColorView.ViewModel = UserColorView.ViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    colorProvider.delegate = self
    iconProvider.delegate = self
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    title = "Dynamic SwiftUI Content"
    view.backgroundColor = .systemBackground

    let contentStackView = UIStackView(arrangedSubviews: [
      colorView,
      colorPicker,
      iconPicker,
      UIView() // A spacer, just to prevent stretching across the entire UIViewController
    ])
    contentStackView.axis = .vertical
    contentStackView.spacing = 16
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      contentStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      contentStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      contentStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
    ])
  }
}

extension DynamicSwiftUIViewController: IconPickerDelegate {
  func didPick(icon systemName: String) {
    self.viewModel.selectedIconName = systemName
  }
}

extension DynamicSwiftUIViewController: ColorPickerDelegate {
  func didPick(color: Color) {
    self.viewModel.preferredColor = color
  }
}
