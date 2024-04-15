import UIKit
import Factory

class AppRouter: ViperRouter {
    static var shared = AppRouter()
}

extension AppRouter: NoteListRouter {
    func viewForLogin(withMessage message: String, delegate: LoginViewDelegate) -> UIViewController {
        let view = Container.shared.viewForLogin()
        view.message = message
        view.delegate = delegate
        return view
    }
    
    func viewForCreatingNote(withDelegate delegate: EditorDelegate) -> UIViewController {
        let view = Container.shared.viewForNote()
        view.delegate = delegate
        view.editMode = .create
        return view
    }
    
    func viewForEditingNote(withUUID uuid: String, title: String, content: String, delegate: EditorDelegate) -> UIViewController {
        let view = Container.shared.viewForNote()
        view.delegate = delegate
        view.editMode = .modify
        
        EditorBuilder.injectCurrentEditingNote(
            viewController: view,
            uuid: uuid,
            title: title,
            content: content)

        return view
    }
}

extension Container {
    var noteListDataService: Factory<NoteListDataSourceInterface> {
        Factory(self) {
            NoteDataManager.shared
        }
    }

    var loginService: Factory<LoginService> {
        Factory(self) {
            LoginService.shared
        }
    }

    var router: Factory<AppRouter> {
        Factory(self) {
            AppRouter.shared
        }
    }

    var viewForNoteList: Factory<NoteListViewController> {
        Factory(self) {
            NoteListModuleBuilder.getView(router: self.router()) as! NoteListViewController
        }.singleton
    }

    var viewForLogin: Factory<LoginViewController> {
        Factory(self) {
            let view = LoginBuilder.getView(router: self.router()) as! LoginViewController
            LoginBuilder.injectLoginService(for: view, loginService: self.loginService())
            return view
        }
    }

    var viewForNote: Factory<EditorViewController> {
        Factory(self) {
            EditorBuilder.getView(router: self.router()) as! EditorViewController
        }
    }
}



