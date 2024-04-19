import Foundation
import UIKit

struct Emoji: Hashable, @unchecked Sendable, Identifiable {
  /// Nickname given to an emoji, matching a CLDR-like short name from the Unicode Full Emoji List.
  let alias: String

  /// Unicode or image value, displaying rich emoji representation.
  let raw: NSAttributedString

  /// Base string value, used for raw human-editable text. May be Unicode or ASCII representation.
  let replacementValue: String

  let category: EmojiCategory

  init(
    alias: String,
    raw: NSAttributedString,
    replacementValue: String,
    category: EmojiCategory
  ) {
    self.alias = alias
    self.raw = raw
    self.replacementValue = replacementValue
    self.category = category
  }

  static var all: [Emoji] = EmojiCategory.allCases.flatMap(\.allEmojis)

  var id: String { alias }
}

enum EmojiCategory: Int, Identifiable, CaseIterable, Hashable, Sendable {
  case smileys, people, animals, food, travel, activities, objects, symbols, flags
  var id: String { name }
  var name: String {
    switch self {
    case .smileys:
      "Smileys & Emotion"
    case .people:
      "People & Body"
    case .animals:
      "Animals & Nature"
    case .food:
      "Food & Drink"
    case .travel:
      "Travel & Places"
    case .activities:
      "Activities"
    case .objects:
      "Objects"
    case .symbols:
      "Symbols"
    case .flags:
      "Flags"
    }
  }

  public var allEmojis: [Emoji] {
    emojiData
      .compactMap { key, value -> Emoji? in
        guard let category = emojiCategories[key] else { return nil }
        return Emoji(
          alias: key,
          raw: NSAttributedString(string: value),
          replacementValue: value,
          category: category
        )
      }
      .filter { $0.category == self }
  }

  public static func `for`(alias: String) -> EmojiCategory? {
    emojiCategories[alias]
  }

  public init?(categoryName: String) {
    guard let category = EmojiCategory.allCases.first(where: { $0.name == categoryName }) else {
      return nil
    }
    self = category
  }
}
