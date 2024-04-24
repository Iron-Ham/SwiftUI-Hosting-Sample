import SwiftUI

/// Presents the `EmojiPopoverCollectionView` using a `popover_backport` modifier. Otherwise identical to the
/// `StockPopoverView`. 
struct PopoverBackportView: View {
  @State var showEmojiSheet: Bool = false
  @State var selectedEmoji: Emoji?

  var body: some View {
    EmojiBadgeView(showEmojiSheet: $showEmojiSheet, selectedEmoji: $selectedEmoji)
      .accessibilityAddTraits(.isButton)
      .onTapGesture { showEmojiSheet.toggle() }
      .popover_backport(isPresented: $showEmojiSheet) {
        EmojiPopoverCollectionView(selectedEmoji: $selectedEmoji)
          .frame(
            minWidth: 200,
            idealWidth: 400,
            maxWidth: 400,
            minHeight: 200,
            idealHeight: 400,
            maxHeight: 400
          )
      }
  }
}

#Preview {
  PopoverBackportView()
}
