import Foundation
import UIKit

enum NoteListViewPresenterError: Error {
    case initializationError
}

class NoteListViewPresenter: ViperPresenter, 
                             EditorDelegate,
                             LoginViewDelegate, 
                             NoteListViewEventHandler,
                             NoteListViewDataSource,
                             UIViewControllerPreviewingDelegate {

    var wireframe: NoteListWireframe?
    weak var view: NoteListViewController?
    var interactor: NoteListInteractor?

    var logined: Bool = false

    // MARK: - NoteListViewEventHandler
    func handleViewReady() throws {
        guard let wireframe = wireframe, let view = view, let interactor = interactor else {
            throw NoteListViewPresenterError.initializationError
        }
        
        interactor.loadAllNotes()
    }
    
    // func handleViewWillAppear(_ animated: Bool) { }

    func handleViewDidAppear(_ animated: Bool) {
        if !logined {
            wireframe?.presentLoginView(withMessage: "Login in to use this app", delegate: self, completion: nil)
        }
    }
    
    // func handleViewWillDisappear(_ animated: Bool) { }

    // func handleViewDidDisappear(_ animated: Bool) { }

    // func handleViewRemoved() { }
    
    func didTouchNavigationBarAddButton() {
        wireframe?.presentEditorForCreatingNewNote(withDelegate: self, completion: nil)
    }

    func canEditRowAt(_ indexPath: IndexPath) -> Bool {
        return true
    }

    func handleDeleteCellForRowAt(_ indexPath: IndexPath) {
        interactor?.deleteNote(atIndex: indexPath.row)
    }

    func handleDidSelectRowAt(_ indexPath: IndexPath) {
        guard let interactor = interactor else {
            return
        }
        let uuid = interactor.noteUUID(atIndex: indexPath.row) ?? ""
        let title = interactor.noteTitle(atIndex: indexPath.row) ?? ""
        let content = interactor.noteContent(atIndex: indexPath.row) ?? ""
        wireframe?.pushEditorViewForEditingNote(withUUID: uuid, title: title, content: content, delegate: self)
    }

    // MARK: - NoteListViewDataSource
    func numberOfRowsInSection(_ section: Int) -> Int {
        return interactor?.noteCount ?? 0
    }
    
    func textOfCellForRowAt(_ indexPath: IndexPath) -> String {
        return interactor?.titleForNote(atIndex: indexPath.row) ?? ""
    }
    
    func detailTextOfCellForRowAt(_ indexPath: IndexPath) -> String {
        return interactor?.contentForNote(atIndex: indexPath.row) ?? ""
    }

    // MARK: - LoginViewDelegate
    func loginViewController(_ loginViewController: UIViewController, didLoginWithAccount account: String) {
        logined = true
        wireframe?.dismissLoginView(loginViewController, animated: true, completion: nil)
    }
    
    // MARK: - EditorDelegate
    func editor(_ editor: UIViewController, didFinishEditNote note: NoteModel) {
        wireframe?.quitEditorView(animated: true)
        view?.noteListTableView.reloadData()
    }

    // MARK: - UIViewControllerPreviewingDelegate

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = view?.noteListTableView.indexPathForRow(at: location),
              let uuid = interactor?.noteUUIDAtIndex(indexPath.row),
              let title = interactor?.noteTitleAtIndex(indexPath.row),
              let content = interactor?.noteContentAtIndex(indexPath.row),
              let destinationViewController = wireframe?.editorViewForEditingNote(withUUID: uuid, title: title, content: content, delegate: self) else {
            return nil
        }

        // Setting the sourceRect to improve the user experience with 3D Touch
        previewingContext.sourceRect = view?.noteListTableView.rectForRow(at: indexPath) ?? .zero

        return destinationViewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // Assuming `view` conforms to a protocol that provides a route source.
        // Update or customize based on your actual view's capabilities.
        if let routeSource = view?.routeSource {
            wireframe?.pushEditorViewController(viewControllerToCommit, from: routeSource, animated: true)
        }
    }
}
