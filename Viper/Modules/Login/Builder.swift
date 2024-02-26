import UIKit

class LoginBuilder: ViperBuilder {
    static func view(withMessage message: String, delegate: LoginViewDelegate, router: ViperRouter) throws -> UIViewController {
        let view = LoginViewController()
        view.delegate = delegate
        view.message = message
        self.buildView(view: view, router: router)
        return view
    }

    private static func buildView(view: ViperView, router: ViperRouter) {
        guard let view = view as? LoginViewController else {
            fatalError("view must be an instance of LoginViewController")
        }
        let presenter = LoginViewPresenter()
        let interactor = LoginInteractor()
        let wireframe = LoginViewWireframe()

        try assembleViper(forView: view, presenter: presenter, interactor: interactor, wireframe: wireframe, router: router)
    }
}
