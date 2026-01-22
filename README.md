<div align="center">

# ShareKit

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FShareKit%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FShareKit%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

## Overview

A lightweight Swift package that brings full-control sharing to SwiftUI by wrapping `UIActivityViewController` in a clean, composable API.

`ShareKit` is designed as a more flexible alternative to SwiftUI’s `ShareLink`, allowing you to:

- Provide custom activity items
- Exclude specific system share actions
- Inject custom `UIActivity` instances
- Receive detailed completion callbacks
- Present a fully configured share sheet from SwiftUI

## Installation

Add `ShareKit` to your project using Swift Package Manager.

```swift
.package(url: "https://github.com/markbattistella/ShareKit.git", from: "1.0.0")
```

Then import it where needed:

```swift
import ShareKit
```

## Core Concepts

### `Shareable`

`Shareable` defines what gets shared.

```swift
public protocol Shareable {
    var activityItems: [Any] { get }
    var applicationActivities: [UIActivity]? { get }
    var excludedActivityTypes: [UIActivity.ActivityType]? { get }
}
```

Default implementations mean you only need to supply what you care about.

### `Callback`

A completion handler that mirrors UIActivityViewController:

```swift
public typealias Callback = (
    _ activityType: UIActivity.ActivityType?,
    _ completed: Bool,
    _ returnedItems: [Any]?,
    _ error: Error?
) -> Void
```

## Usage

### 1. Create a `Shareable`

```swift
struct ArticleShare: Shareable {
    let url: URL

    var activityItems: [Any] {
        [url]
    }

    var excludedActivityTypes: [UIActivity.ActivityType]? {
        [.assignToContact]
    }
}
```

### 2. Present with `UIShareLink`

```swift
UIShareLink(
    "Share Article",
    content: ArticleShare(url: articleURL)
) { activity, completed, _, error in
    if completed {
        print("Shared via \(activity?.rawValue ?? "unknown")")
    }
}
```

Using a Custom Label

```swift
UIShareLink(
    content: ArticleShare(url: articleURL),
    callback: { _, completed, _, _ in
        if completed {
            print("Done")
        }
    }
) {
    Label("Share", systemImage: "square.and.arrow.up")
}
```

### Behaviour Notes

- The share sheet is presented modally using `.sheet`
- Medium and large detents are enabled
- Background interaction is disabled
- Interactive dismissal is prevented to ensure callback delivery

These defaults are intentional and mirror common system share behaviour.

## Why Not `ShareLink`?

`ShareLink` is excellent for simple cases, but it does not allow:

- Excluding activity types
- Injecting custom `UIActivity` subclasses
- Accessing the full completion result
- Controlling presentation behaviour

`ShareKit` exists specifically for those gaps.

## Contributing

Contributions are more than welcome. If you find a bug or have an idea for an enhancement, please open an issue or provide a pull request.

Please follow the code style present in the current code base when making contributions.

> [!Note]
> Any pull requests need to have the title in the following format, otherwise it will be rejected.
>
> ```text
> YYYY-mm-dd - {title}
> eg. 2023-08-24 - Updated README file
> ```

I like to track the day from logged request to completion, allowing sorting, and extraction of data. It helps me know how long things have been pending and provides structure.

## Licence

`ShareKit` is released under the MIT license. See LICENCE for details.
