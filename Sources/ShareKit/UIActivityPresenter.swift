//
// Project: ShareKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import UIKit

/// Presents a `UIActivityViewController` from the active key window's topmost view controller.
///
/// Presenting from the key window's root VC (rather than a SwiftUI-embedded VC) is required for
/// scene-based share extensions. Extensions such as Bluesky use `UIHostedScene` to attach their
/// UI to the presenting app's window scene. If the presenting VC is not properly rooted in an
/// active `UIWindowScene`, iOS invalidates the extension's scene and it never opens.
@MainActor
internal final class UIActivityPresenter {

    /// The activity controller currently being presented.
    private weak var presentedController: UIActivityViewController?

    /// Presents the share sheet for the supplied content.
    ///
    /// - Parameters:
    ///   - content: The content to be shared.
    ///   - callback: A closure invoked when the share activity completes.
    func present(
        content: any Shareable,
        callback: @escaping Callback
    ) {
        guard presentedController == nil else { return }
        guard let presentingVC = activePresentationController() else { return }

        let controller = UIActivityViewController(
            activityItems: content.activityItems,
            applicationActivities: content.applicationActivities
        )
        controller.excludedActivityTypes = content.excludedActivityTypes
        configurePopover(for: controller, presentingFrom: presentingVC)
        controller.completionWithItemsHandler = {
            [weak self] activityType, completed, returnedItems, error in
            self?.presentedController = nil
            callback(activityType, completed, returnedItems, error)
        }

        presentedController = controller
        presentingVC.present(controller, animated: true)
    }

    // MARK: - Helpers

    private func activePresentationController() -> UIViewController? {
        let viewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first { $0.isKeyWindow }?
            .rootViewController
            .map(topMost(from:))

        guard let viewController else { return nil }
        guard !(viewController is UIActivityViewController) else { return nil }
        guard !viewController.isBeingDismissed else { return nil }
        return viewController
    }

    private func topMost(from vc: UIViewController) -> UIViewController {
        if let presented = vc.presentedViewController {
            return topMost(from: presented)
        }
        return vc
    }

    private func configurePopover(
        for controller: UIActivityViewController,
        presentingFrom presentingVC: UIViewController
    ) {
        guard let popover = controller.popoverPresentationController else { return }
        guard let sourceView = presentingVC.view else { return }

        popover.sourceView = sourceView
        popover.sourceRect = CGRect(
            x: sourceView.bounds.midX,
            y: sourceView.bounds.midY,
            width: 0,
            height: 0
        )
        popover.permittedArrowDirections = []
    }
}
