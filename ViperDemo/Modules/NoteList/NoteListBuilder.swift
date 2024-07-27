import UIKit

class NoteListModuleBuilder: ViperBuilder {
    static func getView(router: ViperRouter? = nil) -> ViperView? {
        let viewController = NoteListViewController()
        let presenter: ViperPresenter = NoteListViewPresenter()
        let interactor: ViperInteractor = NoteListInteractor()
        let wireframe: ViperWireframe = NoteListWireframe()

        NoteListModuleBuilder.viperAssemble(
            for: viewController,
            presenter: presenter,
            interactor: interactor,
            wireframe: wireframe,
            router: AppRouter.shared)
        return viewController
    }
    // 为 viper 架构的 interactor 注入 noteListDataService
    static func injectNoteListDataService(for viewController: ViperView, noteListDataService: NoteListDataSourceInterface) {
        var noteListDataService = noteListDataService

        guard let viewController = viewController as? NoteListViewController else { return }
        guard let interactor = viewController.viewDataSource?.interactor as? NoteListInteractor else { return }
        interactor.noteListDataService = noteListDataService
        noteListDataService.addObserver(interactor)
    }
}

