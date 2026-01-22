//
// Project: ShareKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import UIKit

/// A type that supplies content for a share sheet.
///
/// Conforming types describe what should be shared, optionally providing custom activities and
/// excluding specific system activity types.
public protocol Shareable {

    /// The items to be shared.
    var activityItems: [Any] { get }

    /// Custom application-specific activities.
    var applicationActivities: [UIActivity]? { get }

    /// Activity types that should be excluded from the share sheet.
    var excludedActivityTypes: [UIActivity.ActivityType]? { get }
}

/// Default implementations for optional `Shareable` requirements.
public extension Shareable {

    /// Default implementation returns no custom activities.
    var applicationActivities: [UIActivity]? { nil }

    /// Default implementation excludes no activity types.
    var excludedActivityTypes: [UIActivity.ActivityType]? { nil }
}

/// A completion handler invoked when a share activity finishes.
///
/// - Parameters:
///   - activityType: The selected activity type, if any.
///   - completed: A Boolean value indicating whether the activity completed.
///   - returnedItems: Any items returned by the activity.
///   - error: An error that occurred during the activity, if any.
public typealias Callback = (
    _ activityType: UIActivity.ActivityType?,
    _ completed: Bool,
    _ returnedItems: [Any]?,
    _ error: Error?
) -> Void
