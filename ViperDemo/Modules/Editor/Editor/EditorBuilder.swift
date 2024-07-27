import UIKit

class EditorBuilder: ViperBuilder {

    static func getView(router: ViperRouter? = nil) -> ViperView? {
            let viewController = EditorViewController()
            let presenter: ViperPresenter = EditorViewPresenter()
            let interactor: ViperInteractor = EditorInteractor()
            let wireframe: ViperWireframe = EditorWireframe()

            // view.delegate = delegate
            // view.editMode = .create
            // note: NoteModel(uuid: uuid, title: title, content: content)
            // router

            NoteListModuleBuilder.viperAssemble(
                for: viewController,
                presenter: presenter,
                interactor: interactor,
                wireframe: wireframe,
                router: AppRouter.shared)

            return viewController
        }

    static func injectCurrentEditingNote(
        viewController: ViperView,
        uuid: String,
        title: String,
        content: String) {
            if let interactor = (viewController as? EditorViewController)?.viewDataSource?.interactor as? EditorInteractor {
            interactor.editingNote = NoteModel(uuid: uuid, title: title, content: content)
        }
    }

    // 为 viper 架构的 interactor 注入 noteListDataService
    static func injectEditorDataService(for viewController: ViperView, editorDataService: EditorDataSourceInterface) {
        let editorDataService = editorDataService

        guard let viewController = viewController as? EditorViewController else { return }
        guard let interactor = viewController.viewDataSource?.interactor as? EditorInteractor else { return }
        interactor.noteDataService = editorDataService
//        editorDataService.addObserver(interactor)
    }
}
