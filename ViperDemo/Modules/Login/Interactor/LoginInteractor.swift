import Foundation

class LoginInteractor: ViperInteractor, LoginInteractorInterface {
    var dataSource: ViperPresenter? = nil
    var eventHandler: ViperPresenter? = nil
    var loginService: LoginServiceInterface? = nil

    func login(withAccount account: String, password: String, success: @escaping () -> Void, error: @escaping () -> Void) {
        self.loginService?.login(withAccount: account, password: password, success: success, error: error)
    }
}

