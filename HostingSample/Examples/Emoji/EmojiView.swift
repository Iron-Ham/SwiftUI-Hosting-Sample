import SwiftUI

struct EmojiView: View {
  @ScaledMetric(relativeTo: .body) private var bodyHeight = UIFont.preferredFont(forTextStyle: .body).pointSize

  // We use a fixed on-scaling `largeTitle1` font size, as per Apple's current Typography guidelines.
  // We intentionally do not want to pick the scaling variant – as this is an instance where we
  // don't want these elements to scale with the user's accessibility setting. This is done to mimic
  // the system default popover emoji picker behavior on iPadOS, which does not scale with dynamic
  // font size.
  private let titleHeight: CGFloat = 34

  var emoji: Emoji
  var usesBodyScaling = true

  var body: some View {
    Text(emoji.replacementValue)
      .lineLimit(1)
      .minimumScaleFactor(0.01)
      .font(usesBodyScaling ? .body : .title)
      .frame(
        width: usesBodyScaling ? bodyHeight : titleHeight,
        height: usesBodyScaling ? bodyHeight : titleHeight
      )
  }
}
