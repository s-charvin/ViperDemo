import Foundation

class EditorViewPresenter: ViperPresenter, 
                           EditorViewEventHandler,
                           EditorViewDataSource,
                           EditorInteractorEventHandler,
                           EditorInteractorDataSource {
    // MARK: - ViperPresenter
    var wireframe: EditorWireframeInterface?
    weak var view: ViewInterface?
    var interactor: EditorInteractorInterface?

    // MARK: - EditorViewEventHandler
    func didTouchNavigationBarDoneButton() throws {
        try interactor?.storeCurrentEditingNote()
        if let delegate = view?.delegate, let note = interactor?.currentEditingNote() {
            delegate.editor(didFinishEditNote: note)
        }
    }

    var router: ViperRouter? {
        return wireframe?.router
    }

    func handleViewReady() throws {
        guard let wireframe = wireframe, let view = view, let interactor = interactor else {
            throw InitializationError.componentNotInitialized
        }

        if view.editMode == .modify {
            view.updateTitleString(interactor.currentEditingNoteTitle())
            view.updateContentString(interactor.currentEditingNoteContent())
        }
    }

    // func handleViewWillAppear(_ animated: Bool) {}

    // func handleViewDidAppear(_ animated: Bool) {}

    // func handleViewWillDisappear(_ animated: Bool) {}

    // func handleViewDidDisappear(_ animated: Bool) {}

    // func handleViewRemoved() {}

    // MARK: - EditorViewDataSource
    func prefixStringForTextView() -> String {
        return " Demo for Viper."
    }

    // MARK: - EditorInteractorEventHandler

    // MARK: - EditorInteractorDataSource
    func currentEditingNoteTitle() -> String? {
        return view?.titleString
    }

    func currentEditingNoteContent() -> String? {
        return view?.contentString
    }
}

enum InitializationError: Error {
    case componentNotInitialized
    case invalidViewProtocol
}
