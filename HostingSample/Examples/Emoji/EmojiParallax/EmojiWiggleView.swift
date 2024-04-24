import SwiftUI

/// This `View` accepts movement data from the device's gyroscope, specifically the `pitch` and `roll` values.
/// If this is used on a simulator, the emoji will "wiggle" as we send randomly generated `pitch` and `roll` values.
struct EmojiWiggleView: View {
  @Binding var emoji: Emoji
  @State var motionManager = MotionManager()

  var body: some View {
    Text(emoji.replacementValue)
      .font(.largeTitle)
      .animation(.easeInOut) {
        $0.offset(x: motionManager.roll * 100, y: motionManager.pitch * 100)
      }
      .onAppear {
        motionManager.startMonitoringMotionUpdates()
      }
      .onDisappear {
        motionManager.stopMonitoringMotionUpdates()
      }
  }
}

#Preview {
  EmojiWiggleView(emoji: .constant(Emoji.all[0]))
}
