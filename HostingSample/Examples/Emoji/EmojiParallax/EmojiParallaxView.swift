import SwiftUI

struct EmojiParallaxView: View {
  @State var viewModel: ViewModel

  var body: some View {
    VStack {
      EmojiWiggleView(emoji: $viewModel.emoji)

      EmojiSelectionCollectionView(
        selectedEmoji: .init(
          get: { viewModel.emoji },
          set: { newEmoji in
            guard let newEmoji else { return }
            self.viewModel.emoji = newEmoji
          }
        ),
        searchText: $viewModel.searchText
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

extension EmojiParallaxView {
  @Observable final class ViewModel {
    var emoji: Emoji
    var searchText: String?

    init(emoji: Emoji, searchText: String? = nil) {
      self.emoji = emoji
      self.searchText = searchText
    }
  }
}

#Preview {
  EmojiParallaxView(viewModel: EmojiParallaxView.ViewModel(emoji: Emoji.all[0]))
}
