import UIKit
import SwiftUI

/// The `DynamicSwiftUIViewObservableObjectController` is identical to its sibling view controllers within the `Dynamic`
/// examples section. This view controller differentiates itself in that its underlying SwiftUI View uses an `ObservableObject`
/// as opposed to another technique.
final class DynamicSwiftUIViewObservableObjectController: UIViewController {
  private var viewModel: UserColorView2.ViewModel
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

  private lazy var colorView: HostingView<UserColorView2> = HostingView {
    UserColorView2(viewModel: self.viewModel)
  }

  init(viewModel: UserColorView2.ViewModel = UserColorView2.ViewModel()) {
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
    title = "Using an ObservableObject"
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

extension DynamicSwiftUIViewObservableObjectController: IconPickerDelegate {
  func didPick(icon systemName: String) {
    self.viewModel.selectedIconName = systemName
  }
}

extension DynamicSwiftUIViewObservableObjectController: ColorPickerDelegate {
  func didPick(color: Color) {
    self.viewModel.preferredColor = color
  }
}
