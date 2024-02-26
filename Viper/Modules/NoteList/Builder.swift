import UIKit

// 定义可能出现的错误类型
enum ModuleBuilderError: Error {
    case viewControllerTypeMismatch
    case wireframeConformanceMismatch
}

class NoteListModuleBuilder: ViperBuilder {

    static func viewController(withNoteListDataService service: NoteListDataService, router: NoteListRouter) throws -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(withIdentifier: "NoteListViewController") as? NoteListViewController else {
            throw ModuleBuilderError.viewControllerTypeMismatch
        }
        try self.buildView(view, noteListDataService: service, router: router)
        return view
    }
    
    static func buildView(
        _ view: ViperView, 
        noteListDataService: NoteListDataService, 
        router: NoteListRouter) throws {
        guard let viewController = view as? NoteListViewController else {
            throw ModuleBuilderError.viewControllerTypeMismatch
        }
        
        let presenter = NoteListViewPresenter()
        let interactor = NoteListInteractor(noteListDataService: noteListDataService)
        let wireframe = NoteListWireframe()

        guard let wireframe = wireframe as? ViperWireframe else {
            throw ModuleBuilderError.wireframeConformanceMismatch
        }

        try self.assembleViper(
            for: viewController, 
            presenter: presenter, 
            interactor: interactor, 
            wireframe: wireframe, 
            router: router)
            
    }
}
