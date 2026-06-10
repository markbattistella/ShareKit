//
// Project: ShareKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// A SwiftUI view that presents a share sheet when tapped.
///
/// `UIShareLink` behaves similarly to `ShareLink`, but allows for full control over activity
/// configuration and completion handling.
///
/// Unlike wrapping `UIActivityViewController` in a SwiftUI `.sheet()`, this implementation
/// presents the activity controller directly from the UIKit view controller hierarchy. This is
/// necessary for scene-based share extensions (e.g. Bluesky) which require a real UIKit window
/// context to host their extension scene.
public struct UIShareLink<L: View>: View {

    /// The presenter retained across SwiftUI view updates.
    @State
    private var presenter = UIActivityPresenter()

    /// The content to be shared.
    private let content: any Shareable

    /// The callback invoked when sharing completes.
    private let callback: Callback

    /// The label used to render the control.
    private let label: () -> L

    // MARK: - Initialisation

    /// Creates a share link with custom content and label.
    ///
    /// - Parameters:
    ///   - content: A value conforming to `Shareable`.
    ///   - callback: A closure invoked when the share activity completes.
    ///   - label: A view builder that creates the label.
    public init(
        content: any Shareable,
        callback: @escaping Callback,
        @ViewBuilder label: @escaping () -> L
    ) {
        self.content = content
        self.callback = callback
        self.label = label
    }

    // MARK: - View

    /// The content and behaviour of the view.
    public var body: some View {
        Button {
            presenter.present(
                content: content,
                callback: callback
            )
        } label: {
            label()
        }
    }
}

// MARK: - Convenience Initialisers (Text)

extension UIShareLink where L == Text {

    /// Creates a share link with a localised text label.
    public init(
        _ titleKey: LocalizedStringKey,
        content: any Shareable,
        callback: @escaping Callback
    ) {
        self.init(content: content, callback: callback) {
            Text(titleKey)
        }
    }

    /// Creates a share link with a string-based text label.
    public init<S: StringProtocol>(
        _ title: S,
        content: any Shareable,
        callback: @escaping Callback
    ) {
        self.init(content: content, callback: callback) {
            Text(title)
        }
    }
}

// MARK: - Convenience Initialisers (Label)

extension UIShareLink where L == Label<Text, Image> {

    /// Creates a share link with a label containing text and a system image.
    public init<S: StringProtocol>(
        _ title: S,
        systemImage: String,
        content: @escaping () -> any Shareable,
        callback: @escaping Callback
    ) {
        self.init(
            content: content(),
            callback: callback
        ) {
            Label(title, systemImage: systemImage)
        }
    }

    /// Creates a share link with a localised label and system image.
    public init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        content: @escaping () -> any Shareable,
        callback: @escaping Callback
    ) {
        self.init(
            content: content(),
            callback: callback
        ) {
            Label(titleKey, systemImage: systemImage)
        }
    }
}
