//
// Project: ShareKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// A SwiftUI wrapper around `UIActivityViewController`.
///
/// `UIActivityVC` bridges UIKit’s share sheet into SwiftUI using `UIViewControllerRepresentable`.
/// It is intended to be presented modally and configured using a `Shareable` value.
internal struct UIActivityVC: UIViewControllerRepresentable {
    
    /// The content to be shared.
    ///
    /// Provides the activity items, optional custom activities, and any excluded activity types.
    let content: any Shareable
    
    /// An optional completion callback invoked when the activity finishes.
    let callback: Callback?
    
    // MARK: - UIViewControllerRepresentable
    
    /// Creates and configures a `UIActivityViewController`.
    ///
    /// - Parameter context: The context provided by SwiftUI.
    /// - Returns: A configured `UIActivityViewController` instance.
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: content.activityItems,
            applicationActivities: content.applicationActivities
        )
        controller.excludedActivityTypes = content.excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    /// Updates the `UIActivityViewController`.
    ///
    /// This implementation performs no updates because the activity view controller does not
    /// support dynamic content changes.
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}
