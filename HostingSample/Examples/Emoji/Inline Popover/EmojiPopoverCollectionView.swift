import SwiftUI

/// The `EmojiPopoverCollectionView` is a SwiftUI wrapper around `EmojiCollectionViewController`.
/// As it's intended for use in a popover, it automatically dismisses the view after selection. Unlike `EmojiSelectionCollectionView`,
/// it uses the view's internal `UISearchController`, and as a result wraps the `EmojiCollectionViewController` in a
/// `UINavigationController` to let the component handle its own search state.
struct EmojiPopoverCollectionView: UIViewControllerRepresentable {
  @Binding var selectedEmoji: Emoji?
  @Environment(\.dismiss) var dismiss

  func makeUIViewController(context: Context) -> UINavigationController {
    let viewController = EmojiCollectionViewController()
    viewController.delegate = context.coordinator
    return UINavigationController(rootViewController: viewController)
  }

  func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    let viewController = uiViewController.topViewController as? EmojiCollectionViewController
    viewController?.update(selection: selectedEmoji)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

extension EmojiPopoverCollectionView {
  class Coordinator: EmojiCollectionDelegate {
    var parent: EmojiPopoverCollectionView

    init(_ parent: EmojiPopoverCollectionView) {
      self.parent = parent
    }

    func didSelect(_ viewController: EmojiCollectionViewController, emoji: Emoji) {
      if let parentEmoji = parent.selectedEmoji, parentEmoji == emoji {
        parent.selectedEmoji = nil
      } else {
        parent.selectedEmoji = emoji
      }
      viewController.view.endEditing(true)
      // Why two forms of dismissal?
      //   1. UIKit and SwiftUI navigation aren't always communicative of one another. When
      //      dismissing a UIViewController, we aren't gauranteed to toggle any `Binding` that
      //      SwiftUI relies on to keep state in check. This is especially likely in situations
      //      where there is a`FocusState` in SwiftUI and an element which can request first
      //      responder in UIKit.
      //   2. There aren't any negative side-effects of calling both, but failure to call both will
      //      result in the dismissals failing to occur if there is an active search within the
      //      UIKit component.
      viewController.dismiss(animated: true)
      parent.dismiss()
    }
  }
}

#Preview {
  EmojiPopoverCollectionView(selectedEmoji: .constant(nil))
}
