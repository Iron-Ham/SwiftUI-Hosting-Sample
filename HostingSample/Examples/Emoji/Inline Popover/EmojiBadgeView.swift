import SwiftUI

struct EmojiBadgeView: View {
  @Binding var showEmojiSheet: Bool
  @Binding var selectedEmoji: Emoji?
  @ScaledMetric(relativeTo: .body) var emojiHeight = UIFont.preferredFont(forTextStyle: .body).pointSize

  private var emojiBadgeColor: Color {
    if showEmojiSheet || selectedEmoji != nil {
      return .blue
    } else {
      return .gray
    }
  }

  @MainActor private var emojiImage: some View {
    Group {
      if let selectedEmoji {
        EmojiView(emoji: selectedEmoji)
      } else {
        Label {
          EmptyView()
        } icon: {
          Image(systemName: "face.smiling")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
        }.labelStyle(.iconOnly)
      }
    }
  }

  @MainActor private var rectangle: some Shape {
    RoundedRectangle(cornerRadius: 8, style: .continuous)
  }

  var body: some View {
    emojiImage
      .foregroundColor(emojiBadgeColor)
      .frame(width: emojiHeight, height: emojiHeight)
      .padding(8)
      .background(emojiBadgeColor.opacity(0.1))
      .clipShape(rectangle)
      .overlay(rectangle.stroke(emojiBadgeColor.opacity(0.2)))
  }
}
