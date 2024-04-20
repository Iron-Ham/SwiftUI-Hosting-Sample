import SwiftUI

public final class HostingView<Content>: UIView where Content: View {
  private let hostingController: UIHostingController<Content>
  public var rootView: Content { hostingController.rootView }

  public convenience init(@ViewBuilder content: () -> Content) {
    self.init(content: content())
  }

  public init(content: Content) {
    self.hostingController = UIHostingController(rootView: content)
    super.init(frame: .zero)
    self.backgroundColor = .clear
    self.hostingController.view.backgroundColor = .clear
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func didMoveToWindow() {
    super.didMoveToWindow()
    guard window != nil else { return }
    setUpHostingControllerIfNeeded()
  }

  private func setUpHostingControllerIfNeeded() {
    guard let parent = nextViewController else {
      return assertionFailure("No UIViewController found")
    }
    guard hostingController.parent !== parent else { return }
    if hostingController.parent != nil {
      hostingController.remove()
    }

    parent.add(hostingController, contentView: self)
    layoutIfNeeded()
  }
}

private extension UIViewController {
  /// Adds a child `UIViewController` to `UIViewController`
  /// - Parameters:
  ///   - child: The child `UIViewController` to add
  ///   - layoutGuide: An optional UILayoutGuide to pin the  child `UIViewController` to. If this is nil, the child will pin itself to the parent.
  func add(
    _ child: UIViewController,
    contentView: UIView? = nil,
    layoutGuide: UILayoutGuide? = nil
  ) {
    addChild(child)
    let superView: UIView = contentView ?? self.view
    superView.addSubview(child.view)
    child.view.translatesAutoresizingMaskIntoConstraints = false
    if let layoutGuide {
      NSLayoutConstraint.activate([
        child.view.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
        child.view.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
        child.view.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
        child.view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
      ])
    } else {
      NSLayoutConstraint.activate([
        child.view.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
        child.view.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
        child.view.topAnchor.constraint(equalTo: superView.topAnchor),
        child.view.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
      ])
    }
    child.didMove(toParent: self)
  }

  /// Removes the child `UIViewController` from the parent
  func remove() {
    // Just to be safe, we check that this view controller
    // is actually added to a parent before removing it.
    guard parent != nil else {
      return
    }

    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }

}
