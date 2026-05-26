//
// Project: ShareKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// A SwiftUI representable that presents a `UIActivityViewController` from the key window's
/// topmost view controller.
///
/// Presenting from the key window's root VC (rather than a SwiftUI-embedded VC) is required for
/// scene-based share extensions. Extensions such as Bluesky use `UIHostedScene` to attach their
/// UI to the presenting app's window scene. If the presenting VC is not properly rooted in an
/// active `UIWindowScene`, iOS invalidates the extension's scene and it never opens.
internal struct UIActivityVC: UIViewControllerRepresentable {

  /// Controls whether the share sheet is presented.
  @Binding var isPresented: Bool

  /// The content to be shared.
  let content: any Shareable

  /// An optional completion callback invoked when the activity finishes.
  let callback: Callback?

  // MARK: - UIViewControllerRepresentable

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }

  func updateUIViewController(_ viewController: UIViewController, context: Context) {
    guard isPresented else { return }
    guard context.coordinator.presentedController == nil else { return }
    guard let presentingVC = activePresentationController() else { return }

    let controller = UIActivityViewController(
      activityItems: content.activityItems,
      applicationActivities: content.applicationActivities
    )
    controller.excludedActivityTypes = content.excludedActivityTypes
    controller.completionWithItemsHandler = { activityType, completed, returnedItems, error in
      context.coordinator.presentedController = nil
      isPresented = false
      callback?(activityType, completed, returnedItems, error)
    }

    context.coordinator.presentedController = controller
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

  // MARK: - Coordinator

  final class Coordinator {
    weak var presentedController: UIActivityViewController?
  }
}
