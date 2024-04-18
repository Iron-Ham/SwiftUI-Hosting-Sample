import UIKit
import SwiftUI

protocol IconPickerDelegate: AnyObject {
  func didPick(icon systemName: String)
}

class IconPickerDataProvider: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
  let icons = Icons.allCases

  weak var delegate: IconPickerDelegate?

  func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

  func pickerView(
    _ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int
  ) -> Int {
    icons.count
  }

  func pickerView(
    _ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int
  ) -> String? {
    icons[row].title
  }

  func pickerView(
    _ pickerView: UIPickerView,
    didSelectRow row: Int,
    inComponent component: Int
  ) {
    delegate?.didPick(icon: icons[row].iconName)
  }
}

enum Icons: CaseIterable {
  case question, scribble, trash, terminal, calendar

  var iconName: String {
    switch self {
    case .question:
      "questionmark"
    case .scribble:
      "scribble"
    case .trash:
      "trash"
    case .terminal:
      "apple.terminal"
    case .calendar:
      "calendar"
    }
  }

  var title: String {
    switch self {
    case .question:
      "Question"
    case .scribble:
      "Scribble"
    case .trash:
      "Trash"
    case .terminal:
      "Terminal"
    case .calendar:
      "Calendar"
    }
  }
}
