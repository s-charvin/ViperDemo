import UIKit

// Routable protocol for more generic routing
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
    var viewController: UIViewController {
        return self.rootViewController ?? UIViewController()
    }
    var window: UIWindow? {
        return self
    }
}

// protocol ViperRouter {
//     static func pushViewController(_ viewController: UIViewController, to destination: UIViewController, animated: Bool)
//     static func popViewController(_ viewController: UIViewController, animated: Bool) -> UIViewController?
//     static func presentViewController(_ viewControllerToPresent: UIViewController, from source: UIViewController, animated: Bool, completion: (() -> Void)?)
//     static func dismissViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)


// }

/// pushViewController: 将 ViewController 推入目标的导航控制器堆栈
/// popViewController: 从导航控制器堆栈中弹出 ViewController
/// presentViewController: 在目标 ViewController 上呈现 ViewController
/// dismissViewController: 从当前 ViewController 上解散 ViewController
/// addChildViewController: 将 ViewController 添加为父 ViewController 的子 ViewController
/// removeChildViewController: 将 ViewController 从父 ViewController 的子 ViewController 中移除

protocol ViperRouter {
    static func pushViewController(_ viewController: Routable, to destination: Routable, animated: Bool, usingTransition transition: UIViewControllerAnimatedTransitioning?) throws
    static func popViewController(_ viewController: Routable, animated: Bool) throws -> UIViewController? 
    static func presentViewController(_ viewControllerToPresent: Routable, from source: Routable, animated: Bool, completion: (() -> Void)?, usingTransition transition: UIViewControllerTransitioningDelegate?) throws
    static func dismissViewController(_ viewController: Routable, animated: Bool, completion: (() -> Void)?) throws
    // TODO: 子视图控制器的添加和移除和多窗口视图管理
    static func addChildViewController(_ childViewController: Routable, to parentViewController: Routable, into containerView: UIView?) throws
    static func removeChildViewController(_ childViewController: Routable)
    static func createWindow(rootViewController: Routable, scene: UIWindowScene) throws -> UIWindow
    static func pushViewControllerInNewWindow(_ viewController: Routable, scene: UIWindowScene, animated: Bool, usingTransition transition: UIViewControllerAnimatedTransitioning?) throws
    static func switchRootViewController(for window: Routable, to newRootViewController: Routable, animated: Bool, completion: (() -> Void)?) throws
}

