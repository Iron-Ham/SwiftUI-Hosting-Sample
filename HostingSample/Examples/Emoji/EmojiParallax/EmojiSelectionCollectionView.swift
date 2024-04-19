import SwiftUI

struct EmojiSelectionCollectionView: UIViewControllerRepresentable {
  @Binding var selectedEmoji: Emoji?

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

extension EmojiSelectionCollectionView {
  class Coordinator: EmojiCollectionDelegate {
    var parent: EmojiSelectionCollectionView

    init(_ parent: EmojiSelectionCollectionView) {
      self.parent = parent
    }

    func didSelect(_ viewController: EmojiCollectionViewController, emoji: Emoji) {
      if let parentEmoji = parent.selectedEmoji, parentEmoji == emoji {
        parent.selectedEmoji = nil
      } else {
        parent.selectedEmoji = emoji
      }
    }
  }
}

#Preview {
  EmojiPopoverCollectionView(selectedEmoji: .constant(nil))
}
