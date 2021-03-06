//
//  ViewControllerAssembly.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Swinject

final class MapViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MapViewController.self) { _ in
            let vc = StoryboardScene.Main.mapViewController.instantiate()
            return vc
        }
    }
}
extension MapViewController {
    static func newInstance() -> MapViewController {
        let vc =  Container.shareResolver.resolve(MapViewController.self)!
        return vc
    }
}

final class MonthViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MonthViewController.self) { _ in
            let vc = StoryboardScene.Main.monthViewController.instantiate()
            return vc
        }
    }
}
extension MonthViewController {
    static func newInstance() -> MonthViewController {
        let vc =  Container.shareResolver.resolve(MonthViewController.self)!
        return vc
    }
}

final class AssetDetailViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AssetDetailViewController.self) { _ in
            let vc = StoryboardScene.Main.assetDetailViewController.instantiate()
            return vc
        }
    }
}
extension AssetDetailViewController {
    static func newInstance() -> AssetDetailViewController {
        let vc =  Container.shareResolver.resolve(AssetDetailViewController.self)!
        return vc
    }
}

final class PaymentViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PaymentViewController.self) { _ in
            let vc = StoryboardScene.Main.paymentViewController.instantiate()
            return vc
        }
    }
}
extension PaymentViewController {
    static func newInstance() -> PaymentViewController {
        let vc =  Container.shareResolver.resolve(PaymentViewController.self)!
        return vc
    }
}

final class SelectedViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SelectedViewController.self) { _ in
            let vc = StoryboardScene.Main.selectedViewController.instantiate()
            return vc
        }
    }
}
extension SelectedViewController {
    static func newInstance() -> SelectedViewController {
        let vc =  Container.shareResolver.resolve(SelectedViewController.self)!
        return vc
    }
}

final class AddVariantViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AddVariantViewController.self) { _ in
            let vc = StoryboardScene.Main.addVariantViewController.instantiate()
            return vc
        }
    }
}
extension AddVariantViewController {
    static func newInstance() -> AddVariantViewController {
        let vc =  Container.shareResolver.resolve(AddVariantViewController.self)!
        return vc
    }
}
