import SwiftUI

/// The `EmojiSelectionCollectionView` is a SwiftUI wrapper around `EmojiCollectionViewController`.
/// It directly displays the `EmojiCollectionViewController`, and allows for updates to its internal properties.
struct EmojiSelectionCollectionView: UIViewControllerRepresentable {
  @Binding var selectedEmoji: Emoji?
  @Binding var searchText: String?

  func makeUIViewController(context: Context) -> EmojiCollectionViewController {
    let viewController = EmojiCollectionViewController(embedSearchBarIntoNavigationTitleView: false)
    viewController.delegate = context.coordinator
    return viewController
  }

  func updateUIViewController(_ uiViewController: EmojiCollectionViewController, context: Context) {
    uiViewController.update(selection: selectedEmoji)
    uiViewController.update(searchText: searchText ?? "")
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

extension EmojiSelectionCollectionView {
  /// The `Coordinator` conforms to the `EmojiCollectionDelegate` protocol and can communicate selected `Emoji`
  /// values to the stored `Binding<Emoji?>`.
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
