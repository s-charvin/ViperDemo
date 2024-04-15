import Foundation
import UIKit



class LoginViewPresenter: ViperPresenter, LoginViewEventHandler {

    weak var view: ViperView?
    var interactor: ViperInteractor?
    var wireframe: ViperWireframe?

    // MARK: - LoginViewEventHandler
    func didTouchLoginButton() {

        guard let view = self.view as? LoginViewController,
            let interactor = self.interactor as? LoginInteractor,
            let account = view.account,
            let password = view.password
        else {
            return
        }

        interactor.login(
            withAccount: account,
            password: password,
            success: {
            if let delegate = view.delegate {
                delegate.loginViewController(view, didLoginWithAccount: account)
            }
        }, error: {
            // Handle error
        })
    }
}
