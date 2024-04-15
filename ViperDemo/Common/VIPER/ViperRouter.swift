import UIKit

protocol Routable {
    var viewController: UIViewController? { get }
    var window: UIWindow? { get }
}

extension UIViewController: Routable {
    var viewController: UIViewController? {
        return self
    }
    var window: UIWindow? {
        return nil
    }
}

extension UIWindow: Routable {

    var viewController: UIViewController? {
        return self.rootViewController
    }

    open override var window: UIWindow? {
        return self
    }
}

protocol ViperRouter: AnyObject {
    static func viperPush(
        _ viewController: Routable,
        to destination: Routable,
        animated: Bool
    )

    static func viperPop(
        _ viewController: Routable,
        animated: Bool
    ) -> Routable?

    static func viperPresent(
        _ viewControllerToPresent: Routable,
        from source: Routable,
        animated: Bool,
        completion: (() -> Void)?
    )

    static func viperDismiss(
        _ viewController: Routable,
        animated: Bool,
        completion: (() -> Void)?
    )
}

    /// addChildViewController: 将 ViewController 添加为父 ViewController 的子 ViewController
    /// removeChildViewController: 将 ViewController 从父 ViewController 的子 ViewController 中移除
extension ViperRouter {

        // TODO: 子视图控制器的添加和移除和多窗口视图管理
        // static func addChild(_ childViewController: Routable, to parentViewController: Routable, into containerView: UIView?) throws
        // static func removeChild(_ childViewController: Routable)
        // static func createWindow(withRootViewController rootViewController: Routable, for scene: UIWindowScene) throws -> UIWindow
        // static func push(_ viewController: Routable, inNewWindowFor scene: UIWindowScene, animated: Bool, with transition: UIViewControllerAnimatedTransitioning?) throws
        // static func switchRootViewController(in window: Routable, onto newRootViewController: Routable, animated: Bool, completion: (() -> Void)?) throws

}


extension ViperRouter {
    // 将一个视图控制器推送到另一个视图控制器的导航堆栈中。这要求目标视图控制器必须已经嵌入在一个 UINavigationController 中。
    static func viperPush(_ viewController: Routable, to destination: Routable, animated: Bool) {
        guard let navigationController = destination.viewController?.navigationController else {
            assertionFailure("Destination view controller is not embedded in a UINavigationController")
            return
        }
        navigationController.pushViewController(viewController.viewController!, animated: animated)
    }

    // 将视图控制器从其所在的导航堆栈中移除
    static func viperPop(_ viewController: Routable, animated: Bool) -> Routable?  {
        guard let navigationController = viewController.viewController?.navigationController else {
            assertionFailure("View controller is not embedded in a UINavigationController")
            return nil
        }
        return navigationController.popViewController(animated: animated)
    }

    // 将一个视图控制器暂时推送到另一个视图控制器的模态堆栈中。
    static func viperPresent(_ viewControllerToPresent: Routable, from source: Routable, animated: Bool, completion: (() -> Void)?) {

        let vc = viewControllerToPresent.viewController
        let sourceVC = source.viewController

        if let navigationController = sourceVC?.navigationController {
            navigationController.present(vc!, animated: animated, completion: completion)
        } else {
            sourceVC?.present(vc!, animated: animated, completion: completion)
        }
    }
    // 从当前视图控制器模态堆栈中移除之前推送的视图控制器，返回到呈现它之前的状态。
    static func viperDismiss(_ viewController: Routable, animated: Bool, completion: (() -> Void)?) {
        let vc = viewController.viewController
        if vc?.presentingViewController == nil {
            assertionFailure("View controller is not presented")
        }
        vc?.dismiss(animated: animated, completion: completion)
    }
}

