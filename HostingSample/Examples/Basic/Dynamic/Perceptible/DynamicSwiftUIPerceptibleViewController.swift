import UIKit
import SwiftUI

// In this example, we showcase using a `HostingView` for SwiftUI content that is dynamic by nature.
final class DynamicSwiftUIPerceptibleViewController: UIViewController {
  private var viewModel: UserColorView3.ViewModel
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

  private lazy var colorView: HostingView<UserColorView3> = HostingView {
    UserColorView3(viewModel: viewModel)
  }

  init(viewModel: UserColorView3.ViewModel = UserColorView3.ViewModel()) {
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
    title = "Using @Perceptible"
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

extension DynamicSwiftUIPerceptibleViewController: IconPickerDelegate {
  func didPick(icon systemName: String) {
    self.viewModel.selectedIconName = systemName
  }
}

extension DynamicSwiftUIPerceptibleViewController: ColorPickerDelegate {
  func didPick(color: Color) {
    self.viewModel.preferredColor = color
  }
}
