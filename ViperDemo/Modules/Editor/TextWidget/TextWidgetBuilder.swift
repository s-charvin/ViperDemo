import UIKit

class TextWidgetBuilder: ViperBuilder {

    static func getView(router: ViperRouter? = nil) -> ViperView? {
        let viewController = TextWidgetView()
        let presenter: ViperPresenter = TextWidgetPresenter()
        let interactor: ViperInteractor = TextWidgetInteractor()
        let wireframe: ViperWireframe = TextWidgetWireframe()

        // view.dataSource = dataSource
        // view.setPrefixText(prefix)
        // router
        // colorForCopyright

        NoteListModuleBuilder.viperAssemble(
            for: viewController,
            presenter: presenter,
            interactor: interactor,
            wireframe: wireframe,
            router: AppRouter.shared)

        return viewController
    }

}



