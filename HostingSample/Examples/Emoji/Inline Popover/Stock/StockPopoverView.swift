import SwiftUI

/// Presents the `EmojiPopoverCollectionView` using a `popover` modifier, with `presentationCompactAdaptation`.
/// Otherwise identical to the `StockPopoverView`.
struct StockPopoverView: View {
  @State var showEmojiSheet: Bool = false
  @State var selectedEmoji: Emoji?

  var body: some View {
    let _ = Self._printChanges()
    EmojiBadgeView(showEmojiSheet: $showEmojiSheet, selectedEmoji: $selectedEmoji)
      .accessibilityAddTraits(.isButton)
      .onTapGesture { showEmojiSheet.toggle() }
      .popover(isPresented: $showEmojiSheet) {
        EmojiPopoverCollectionView(selectedEmoji: $selectedEmoji)
          .frame(
            minWidth: 200,
            idealWidth: 400,
            maxWidth: 400,
            minHeight: 200,
            idealHeight: 400,
            maxHeight: 400
          )
          .presentationCompactAdaptation(.popover)
      }
  }
}

#Preview {
  StockPopoverView()
}
