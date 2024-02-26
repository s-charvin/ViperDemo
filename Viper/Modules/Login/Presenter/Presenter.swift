import Foundation



class LoginViewPresenter: ViperPresenter, LoginViewEventHandler {
    // MARK: - ViperPresenter
    var wireframe: LoginViewWireframe?
    weak var view: LoginViewInterface?
    var interactor: LoginInteractorInterface?

    override func handleViewReady() {
        guard wireframe != nil, view != nil, interactor != nil else {
            fatalError("Initialization Error: Missing components.")
        }
    }

    // MARK: - LoginViewEventHandler
    func didTouchLoginButton() {
        guard let account = view?.account, let password = view?.password else {
            return
        }
        interactor?.login(withAccount: account, password: password, success: { [weak self] in
            if let delegate = self.view?.delegate, let view = self.view as? UIViewController {
                delegate.loginViewController(view, didLoginWithAccount: account)
            }
        }, error: {
            // Handle error
        })
    }
}
