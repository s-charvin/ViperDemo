import UIKit

class LoginBuilder: ViperBuilder {
    static func getView(router: ViperRouter? = nil) -> ViperView? {
        let viewController = LoginViewController()
        let presenter: ViperPresenter = LoginViewPresenter()
        let interactor: ViperInteractor = LoginInteractor()
        let wireframe: ViperWireframe = LoginViewWireframe()

        // view.delegate = delegate
        // view.message = message
        // router

        NoteListModuleBuilder.viperAssemble(
            for: viewController,
            presenter: presenter,
            interactor: interactor,
            wireframe: wireframe,
            router: AppRouter.shared)
        return viewController
    }

    static func injectLoginService(for viewController: ViperView, loginService: LoginService) {
        let loginService = loginService

        guard let viewController = viewController as? LoginViewController else { return }
        guard let interactor = viewController.viewDataSource?.interactor as? LoginInteractor else { return }
        interactor.loginService = loginService
    }
}
