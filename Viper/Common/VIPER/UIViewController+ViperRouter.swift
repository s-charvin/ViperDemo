import UIKit

extension UIViewController {
    private func isAppRootViewController() -> Bool {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
            assertionFailure("Can't find rootViewController")
            return false
        }
        return rootViewController == self
    }
    
    // 判断当前视图控制器是否正在从其父视图控制器中移除
    func isRemoving() -> Bool {
        var node: UIViewController? = self

        while let currentNode = node { // 遍历父视图控制器链
            if currentNode.isMovingFromParent || (!currentNode.parent && !currentNode.presentingViewController && !currentNode.isAppRootViewController()) {
                return true
            } else if currentNode.isBeingDismissed {
                return true
            } else {
                node = currentNode.parent
                continue
            }
            break
        }
        return false
    }
}
