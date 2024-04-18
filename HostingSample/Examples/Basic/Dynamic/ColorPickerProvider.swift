import UIKit
import SwiftUI

protocol ColorPickerDelegate: AnyObject {
  func didPick(color: Color)
}

class ColorPickerDataProvider: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
  let colors = Colors.allCases

  weak var delegate: ColorPickerDelegate?

  func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

  func pickerView(
    _ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int
  ) -> Int {
    colors.count
  }

  func pickerView(
    _ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int
  ) -> String? {
    colors[row].title
  }

  func pickerView(
    _ pickerView: UIPickerView,
    didSelectRow row: Int,
    inComponent component: Int
  ) {
    delegate?.didPick(color: colors[row].color)
  }
}

enum Colors: CaseIterable {
  case blue, red, green, yellow, orange, purple

  var color: Color {
    switch self {
    case .red:
      Color.red
    case .green:
      Color.green
    case .blue:
      Color.blue
    case .yellow:
      Color.yellow
    case .orange:
      Color.orange
    case .purple:
      Color.purple
    }
  }

  var title: String {
    switch self {
    case .red:
      "Red"
    case .green:
      "Green"
    case .blue:
      "Blue"
    case .yellow:
      "Yellow"
    case .orange:
      "Orange"
    case .purple:
      "Purple"
    }
  }
}
