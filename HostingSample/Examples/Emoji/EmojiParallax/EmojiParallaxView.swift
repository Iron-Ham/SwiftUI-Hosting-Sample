import SwiftUI

struct EmojiParallaxView: View {
  @State var emoji: Emoji

  var body: some View {
    VStack {
      EmojiWiggleView(emoji: $emoji)

      EmojiSelectionCollectionView(selectedEmoji: .init(
        get: { emoji },
        set: { newEmoji in
          guard let newEmoji else { return }
          self.emoji = newEmoji
        }
      ))
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

#Preview {
  EmojiParallaxView(emoji: Emoji.all[0])
}
