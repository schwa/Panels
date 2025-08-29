# Panels

A SwiftUI library for dynamically registering and displaying panel views from anywhere in your view hierarchy.

## Installation

Add Panels to your Swift package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/[username]/Panels.git", branch: "main")
]
```

Then add it to your target:

```swift
.target(name: "YourTarget", dependencies: ["Panels"])
```

## Usage

```swift
import Panels
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // Register panels from any view in the hierarchy
            SettingsView()
                .panel(id: "settings", label: "Settings") {
                    SettingsPanel()
                }

            DetailView()
                .panel(id: "details", label: "Details") {
                    DetailPanel()
                }
        }
        .inspector(isPresented: .constant(true)) {
            // Display all registered panels
            Panels { panel in
                DisclosureGroup(panel.label) {
                    panel.body
                }
            }
        }
        .panelsHost() // Required: Sets up the panels environment
    }
}
```

## Requirements

Requirements are mostly arbitrary at this point and could be lowered if needed.

- Swift 6.2+
- macOS 15.0+ / iOS 18.0+ / tvOS 26.0+ / watchOS 26.0+ / visionOS 26.0+

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
