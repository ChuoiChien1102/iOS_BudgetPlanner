// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<MapViewController>(storyboard: Main.self)

    internal static let addVariantViewController = SceneType<AddVariantViewController>(storyboard: Main.self, identifier: "AddVariantViewController")

    internal static let assetDetailViewController = SceneType<AssetDetailViewController>(storyboard: Main.self, identifier: "AssetDetailViewController")

    internal static let mapViewController = SceneType<MapViewController>(storyboard: Main.self, identifier: "MapViewController")

    internal static let monthViewController = SceneType<MonthViewController>(storyboard: Main.self, identifier: "MonthViewController")

    internal static let paymentViewController = SceneType<PaymentViewController>(storyboard: Main.self, identifier: "PaymentViewController")

    internal static let selectedViewController = SceneType<SelectedViewController>(storyboard: Main.self, identifier: "SelectedViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
