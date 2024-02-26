import UIKit

// Error Types
enum RouterError: Error {
    case navigationControllerUnavailable
    case dismissalError
}

class AppRouter: ViperRouter {

    static var shared = AppRouter()

    // 将一个视图控制器推送到另一个视图控制器的导航堆栈中。这要求目标视图控制器必须已经嵌入在一个 UINavigationController 中。
    static func pushViewController(_ viewController: Routable, to destination: Routable, animated: Bool, usingTransition transition: UIViewControllerAnimatedTransitioning? = nil) throws {
        guard let navigationController = destination.viewController.navigationController else {
            throw RouterError.navigationControllerUnavailable
            // return
        }
        if let transition = transition {
            navigationController.delegate = transition as? UINavigationControllerDelegate
        }
        navigationController.pushViewController(viewController.viewController, animated: animated)
    }

    // 将视图控制器从其所在的导航堆栈中移除
    static func popViewController(_ viewController: Routable, animated: Bool) throws -> UIViewController?  {
        guard let navigationController = viewController.viewController.navigationController else {
            throw RouterError.navigationControllerUnavailable
            // return nil
        }
        return navigationController.popViewController(animated: animated)
    }

    // 将一个视图控制器暂时推送到另一个视图控制器的模态堆栈中。
    static func presentViewController(_ viewControllerToPresent: Routable, from source: Routable, animated: Bool, completion: (() -> Void)?, usingTransition transition: UIViewControllerTransitioningDelegate? = nil) throws {
        let vcToPresent = viewControllerToPresent.viewController
        if let transition = transition {
            vcToPresent.transitioningDelegate = transition
        }
        source.viewController.present(vcToPresent, animated: animated, completion: completion)
    }
    // 从当前视图控制器模态堆栈中移除之前推送的视图控制器，返回到呈现它之前的状态。
    static func dismissViewController(_ viewController: Routable, animated: Bool, completion: (() -> Void)?) throws {
        let vc = viewController.viewController
        if vc.presentingViewController == nil {
            throw RouterError.dismissalError
            // return
        }
        vc.dismiss(animated: animated, completion: completion)
    }


    // TODO: 子视图控制器的添加和移除和多窗口视图管理
    
    static func addChildViewController(_ childViewController: Routable, to parentViewController: Routable, into containerView: UIView? = nil) throws {
        let childVC = childViewController.viewController
        let parentVC = parentViewController.viewController
        parentVC.addChild(childVC)
        
        if let containerView = containerView {
            containerView.addSubview(childVC.view)
        } else {
            parentVC.view.addSubview(childVC.view)
        }
        
        childVC.didMove(toParent: parentVC)
    }
    
    static func removeChildViewController(_ childViewController: Routable) throws {
        let childVC = childViewController.viewController
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }

    // 创建新窗口并设置根视图控制器
    static func createWindow(rootViewController: Routable, scene: UIWindowScene) throws -> UIWindow {
        let window = UIWindow(windowScene: scene)
        guard let viewController = rootViewController.viewController else {
            throw RouterError.invalidRootViewController
        }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return window
    }

    // 在新窗口中推送视图控制器
    static func pushViewControllerInNewWindow(_ viewController: Routable, scene: UIWindowScene, animated: Bool, usingTransition transition: UIViewControllerAnimatedTransitioning? = nil) throws {
        let newWindow = try createWindow(rootViewController: viewController, scene: scene)
        if let transition = transition {
            newWindow.rootViewController?.navigationController?.delegate = transition as? UINavigationControllerDelegate
        }
    }

    // 切换窗口的根视图控制器
    static func switchRootViewController(for window: Routable, to newRootViewController: Routable, animated: Bool, completion: (() -> Void)? = nil) throws {
        guard let window = window.window else {
            throw RouterError.windowUnavailable
        }
        guard let viewController = newRootViewController.viewController else {
            throw RouterError.invalidRootViewController
        }
        if animated {
            // 执行动画切换根视图控制器
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewController
            }, completion: { _ in completion?() })
        } else {
            window.rootViewController = viewController
            completion?()
        }
    }
}

