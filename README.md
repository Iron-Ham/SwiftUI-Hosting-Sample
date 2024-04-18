# HostingSample

HostingSample is an iOS project that provides examples and implementation for a custom view called HostingView. The purpose of HostingView is to facilitate the interoperability of SwiftUI views in UIKit-based apps. Developers can seamlessly integrate SwiftUI views directly within any UIView using HostingView.

## Usage

Using `HostingView` is straightforward. Here's a basic example of how to integrate a SwiftUI view into a UIKit-based project:

```swift
import UIKit
import SwiftUI

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingView = HostingView(rootView: MySwiftUIView())
        view.addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: view.topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

struct MySwiftUIView: View {
    var body: some View {
        Text("Hello, SwiftUI!")
            .font(.title)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
```

## Examples

This project includes a few examples to demonstrate the capabilities of `HostingView`. The examples are as follows:

1. **Static SwiftUI Elements**: Demonstrates how to display static SwiftUI elements in a UIKit-based app.
2. **Dynamic SwiftUI Elements**: Demonstrates how to display dynamic SwiftUI elements in a UIKit-based app. There are three variants of this example: one that uses an @Observable macro (iOS 17+), one that uses an `ObservableObject` conformance (iOS 13+), and one that uses `@Perceptible` (iOS 13+). The `@Perceptible` variant is a custom property wrapper that backports the `@Observable` macro's behaviors to iOS 13, and is an open source project available [here](https://github.com/pointfreeco/swift-perception). 
3. **Integrating a UIKit View**: There are two examples that demonstrate how to integrate a UIKit view into a `SwiftUI` view. One example uses the `popover` modifier, while the other uses a custom `popover_backport` modifier that backports the `popover` modifier's behaviors to iOS 13.
