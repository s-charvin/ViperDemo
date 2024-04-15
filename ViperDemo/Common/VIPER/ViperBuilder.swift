import Foundation

protocol  ViperBuilder {
    static func getView(router: ViperRouter?) -> ViperView?
}

extension  ViperBuilder {

    static func viperAssemble(
        for view: ViperView,
        presenter: ViperPresenter?,
        interactor: ViperInteractor?,
        wireframe: ViperWireframe?,
        router: ViperRouter?) {

            let view = view
            let presenter = presenter
            let interactor = interactor
            let wireframe = wireframe

            // View setup
            view.viewDataSource = presenter
            view.eventHandler = presenter

            // Presenter setup
            presenter?.interactor = interactor
            presenter?.view = view
            presenter?.wireframe = wireframe

            // Interactor setup
            interactor?.eventHandler = presenter
            interactor?.dataSource = presenter

            // Wireframe setup
            wireframe?.view = view
            wireframe?.router = router
    }
}
