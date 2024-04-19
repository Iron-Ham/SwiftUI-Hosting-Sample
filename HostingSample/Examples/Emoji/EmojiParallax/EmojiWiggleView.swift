import SwiftUI

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
  }
}

#Preview {
  EmojiWiggleView(emoji: .constant(Emoji.all[0]))
}
