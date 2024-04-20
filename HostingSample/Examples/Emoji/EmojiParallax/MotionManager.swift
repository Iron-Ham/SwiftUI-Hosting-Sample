import CoreMotion
import SwiftUI

@Observable
class MotionManager {

  private let motionManager = CMMotionManager()

  var pitch: Double = 0.0
  var roll: Double = 0.0

  func startMonitoringMotionUpdates() {
    guard self.motionManager.isDeviceMotionAvailable else {
      // We are on a simulator and will be doing a poor mock of this behavior.
      return valuePublisher()
    }

    motionManager.deviceMotionUpdateInterval = 0.01

    motionManager.startDeviceMotionUpdates(to: .main) { motion, _ in
      guard let motion = motion else { return }
      self.pitch = motion.attitude.pitch
      self.roll = motion.attitude.roll
    }
  }

  func stopMonitoringMotionUpdates() {
    self.motionManager.stopDeviceMotionUpdates()
  }

  private func valuePublisher() {
    let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
      self?.pitch = Double.random(in: -0.05 ... 0.05)
      self?.roll = Double.random(in: -0.05 ... 0.05)
    }
    RunLoop.main.add(timer, forMode: .common)
  }
}
