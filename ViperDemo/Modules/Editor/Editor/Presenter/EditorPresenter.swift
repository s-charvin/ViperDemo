import Foundation

class EditorViewPresenter: ViperPresenter, 
                           EditorViewEventHandler,
                           EditorViewDataSource,
                           EditorInteractorEventHandler,
                           EditorInteractorDataSource {


    weak var view: ViperView?
    var wireframe: ViperWireframe?
    var interactor: ViperInteractor?

    // MARK: - EditorViewEventHandler
    func didTouchNavigationBarDoneButton() async {
        guard let interactor = self.interactor as? EditorInteractor,
              let view = self.view as? EditorViewController
        else { return }
        await interactor.storeCurrentEditingNote()
        if let delegate = await view.delegate, let note = interactor.currentEditingNote() {
            delegate.editor(view, didFinishEditNote: note)
        }
    }

    func handleViewReady() {
        guard let view = view as? EditorViewController,
              let interactor = interactor as? EditorInteractor
        else {
            return
        }

        if view.editMode == .modify {
            view.updateTitle(interactor.currentEditingNoteTitle() ?? "")
            view.updateContent(interactor.currentEditingNoteContent() ?? "")
        }
    }

    // MARK: - EditorViewDataSource
    func prefixForTextView() -> String? {
        return " Demo for Viper."
    }

    // MARK: - EditorInteractorEventHandler

    // MARK: - EditorInteractorDataSource
    func currentEditingNoteTitle() -> String? {

        guard let view = self.view as? EditorViewController else {
            return nil
        }
        return view.editorTitle
    }

    func currentEditingNoteContent() -> String? {
        guard let view = self.view as? EditorViewController else {
            return nil
        }
        return view.content
    }
}

enum InitializationError: Error {
    case componentNotInitialized
    case invalidViewProtocol
}
