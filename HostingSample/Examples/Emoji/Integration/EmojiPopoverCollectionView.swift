import SwiftUI

struct EmojiPopoverCollectionView: UIViewControllerRepresentable {
  @Binding var selectedEmoji: Emoji?
  @Environment(\.dismiss) var dismiss

  func makeUIViewController(context: Context) -> UINavigationController {
    let viewController = EmojiCollectionViewController()
    viewController.delegate = context.coordinator
    return UINavigationController(rootViewController: viewController)
  }

  func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    // no-op: As this is a popover, we don't need to update this view. It will dismiss itself.
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
      viewController.dismiss(animated: true)
      parent.dismiss()
    }
  }
}

#Preview {
  EmojiPopoverCollectionView(selectedEmoji: .constant(nil))
}
