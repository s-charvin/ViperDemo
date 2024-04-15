import Foundation
import UIKit

enum NoteListViewPresenterError: Error {
    case initializationError
}

class NoteListViewPresenter: ViperPresenter,
                             NoteListViewEventHandler,
                             NoteListViewDataSource,
                             EditorDelegate,
                             LoginViewDelegate {
    
    weak var view: ViperView? = nil
    var wireframe: ViperWireframe? = nil
    var interactor: ViperInteractor? = nil

    var logined: Bool = false

    // MARK: - NoteListViewEventHandler
    func viperViewIsReady() async {
        guard let interactor = self.interactor as? any NoteListInteractorInterface else {
            return
        }
        await interactor.loadAllNotes()
    }

    func viperViewDidAppear(_ animated: Bool) {
        if !logined {
            guard let wireframe = self.wireframe as? any NoteListWireframeInterface else {
                return
            }
            wireframe.presentLoginView(withMessage: "Login in to use this app", delegate: self, completion: nil)
        }
    }
    
    func didTouchNavigationBarAddButton() {
        guard let wireframe = self.wireframe as? any NoteListWireframeInterface else {
            return
        }
        wireframe.presentEditorForCreatingNewNote(withDelegate: self, completion: nil)
    }

    func canEditRow(at indexPath: IndexPath) -> Bool {
        return true
    }

    func handleDeleteCellForRow(at indexPath: IndexPath) {
        guard let interactor = self.interactor as? NoteListInteractorInterface else {
            return
        }
        interactor.deleteNote(at: UInt(indexPath.row))
    }

    func handleDidSelectRow(at indexPath: IndexPath) {
        guard let interactor = self.interactor as? NoteListInteractorInterface ,
              let wireframe = self.wireframe as? NoteListWireframeInterface
        else {
            return
        }
        let uuid = interactor.noteUUID(at: UInt(indexPath.row)) ?? ""
        let title = interactor.noteTitle(at: UInt(indexPath.row)) ?? ""
        let content = interactor.noteContent(at: UInt(indexPath.row)) ?? ""
        
        wireframe.pushEditorViewForEditingNote(withUUID: uuid, title: title, content: content, delegate: self)
    }

    // MARK: - NoteListViewDataSource
    func numberOfRowsInSection(_ section: Int) -> Int {
        guard let interactor = self.interactor as? NoteListInteractorInterface else {
            return 0
        }
        return interactor.getNoteCount()
    }
    
    func textOfCellForRowAt(indexPath: IndexPath) -> String {
        guard let interactor = self.interactor as? NoteListInteractorInterface else {
            return ""
        }
        return interactor.titleForNote(at: UInt(indexPath.row)) ?? ""
    }
    
    func detailTextOfCellForRowAt(indexPath: IndexPath) -> String {
        guard let interactor = self.interactor as? NoteListInteractorInterface else {
            return ""
        }
        return interactor.contentForNote(at: UInt(indexPath.row)) ?? ""
    }

    // MARK: - LoginViewDelegate
    func loginViewController(_ loginViewController: UIViewController, didLoginWithAccount account: String) {
        self.logined = true
        guard let wireframe = self.wireframe as? NoteListWireframeInterface else {
            return
        }
        wireframe.dismissLoginView(loginViewController, animated: true, completion: nil)
    }
    
    // MARK: - EditorDelegate
    func editor(_ editor: UIViewController, didFinishEditNote note: NoteModel) {
        guard let wireframe = self.wireframe as? NoteListWireframeInterface,
              let view = self.view as? NoteListViewController else {
            return
        }

        wireframe.quitEditorView(animated: true)
        view.noteListTableView.reloadData()
    }
}
