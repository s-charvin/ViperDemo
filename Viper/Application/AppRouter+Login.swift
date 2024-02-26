import UIKit

extension AppRouter {
    static func viewForLogin(withMessage message: String, delegate: LoginViewDelegate) -> UIViewController {
        return LoginBuilder.view(withMessage: message, delegate: delegate, router: AppRouter())
    }
}
