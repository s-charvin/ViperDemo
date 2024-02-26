import UIKit

class EditorBuilder: ViperBuilder {
    static func viewForCreatingNote(delegate: EditorDelegate, router: ViperRouter) throws -> UIViewController {
        let view = EditorViewController()
        view.delegate = delegate
        view.editMode = .create
        buildView(view: view, note: nil, router: router)
        return view
    }

    static func viewForEditingNote(uuid: String, title: String, content: String, delegate: EditorDelegate, router: ViperRouter) throws -> UIViewController {
        let view = EditorViewController()
        view.delegate = delegate
        view.editMode = .modify
        let note = NoteModel(uuid: uuid, title: title, content: content)
        buildView(view: view, note: note, router: router)
        return view
    }

    private static func buildView(view: ViperView, note: NoteModel?, router: ViperRouter) {
        let presenter = EditorViewPresenter()
        let interactor = EditorInteractor(editingNote: note)
        let wireframe = EditorWireframe()

        try assembleViper(forView: view, presenter: presenter, interactor: interactor, wireframe: wireframe, router: router)
    }
}
