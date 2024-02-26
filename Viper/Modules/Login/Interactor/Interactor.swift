import Foundation

class LoginInteractor: ViperInteractor, LoginInteractorInterface {
    weak var dataSource: AnyObject?
    weak var eventHandler: AnyObject?

    func login(withAccount account: String, password: String, success: @escaping () -> Void, error: @escaping () -> Void) {
        LoginService.shared.login(withAccount: account, password: password, success: success, error: error)
    }
}
