import SwiftUI

extension View {
  /// A backport of the `popover` modifier for iOS 16.3 and below.
  /// There are some limitations and caveats to this implementation:
  ///   - The popover will always be presented as a popover, regardless of the size of the content.
  ///   - SwiftUI, at the time of writing this, contains a bug when the environmental variable `dismiss` is being captured in the current view. The bug causes the popover to be dismissed immediately after being presented and re-present, in a continuous loop. To work around this, the `dismiss` variable should not be captured in the same view that the `popover_backport` modifier is being called.
  @MainActor
  func popover_backport<Content>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View where Content: View {
    self.modifier(PopoverBackportModifier(isPresented: isPresented, contentBlock: content))
  }
}

class ContentViewController<V>: UIHostingController<V>, UIPopoverPresentationControllerDelegate
where V: View {
  var isPresented: Binding<Bool>

  init(rootView: V, isPresented: Binding<Bool>) {
    self.isPresented = isPresented
    super.init(rootView: rootView)
  }

  @available(*, unavailable)
  @MainActor @objc dynamic required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let size = sizeThatFits(in: UIView.layoutFittingExpandedSize)
    preferredContentSize = size
  }

  func adaptivePresentationStyle(
    for controller: UIPresentationController,
    traitCollection: UITraitCollection
  ) -> UIModalPresentationStyle {
    return .none
  }

  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    self.isPresented.wrappedValue = false
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.isPresented.wrappedValue = false
  }
}

struct PopoverBackportModifier<PopoverContent>: ViewModifier where PopoverContent: View {
  final class Wrapper: ObservableObject {
    @Published var anchorView = UIView()
  }

  @StateObject private var wrapper = Wrapper()
  let isPresented: Binding<Bool>
  let contentBlock: () -> PopoverContent

  func body(content: Content) -> some View {
    if isPresented.wrappedValue {
      presentPopover()
    }
    return content.background(InternalAnchorView(uiView: wrapper.anchorView))
  }

  private func presentPopover() {
    let contentController = ContentViewController(
      rootView: contentBlock(),
      isPresented: isPresented
    )
    contentController.modalPresentationStyle = .popover

    let view = wrapper.anchorView
    guard let popover = contentController.popoverPresentationController else { return }
    popover.sourceView = view
    popover.sourceRect = view.bounds
    popover.delegate = contentController

    guard let sourceVC = view.nextViewController else { return }
    if let presentedVC = sourceVC.presentedViewController {
      presentedVC.dismiss(animated: true) {
        sourceVC.present(contentController, animated: true)
      }
    } else {
      sourceVC.present(contentController, animated: true)
    }
  }

  private struct InternalAnchorView: UIViewRepresentable {
    typealias UIViewType = UIView
    let uiView: UIView

    func makeUIView(context: Self.Context) -> Self.UIViewType {
      uiView
    }

    func updateUIView(_ uiView: Self.UIViewType, context: Self.Context) { }
  }
}

extension UIResponder {
    // Mimics the private function `_viewControllerForAncestor`
    // `_viewControllerForAncestor` walks up the responder chain looking for the next responder that is a `UIViewController`.
    @nonobjc var nextViewController: UIViewController? {
        guard let next = self.next else { return nil }
        if let next = next as? UIViewController {
            return next
        } else {
            return next.nextViewController
        }
    }
}
