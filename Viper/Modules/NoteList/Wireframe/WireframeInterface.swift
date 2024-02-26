import Foundation
import UIKit

protocol NoteListWireframeInterface {
    func presentLoginView(withMessage message: String, delegate: LoginViewDelegate, completion: (() -> Void)?) throws
    func dismissLoginView(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    
    func presentEditorForCreatingNewNote(withDelegate delegate: EditorDelegate, completion: (() -> Void)?) throws
    func pushEditorViewForEditingNote(withUUID uuid: String, title: String, content: String, delegate: EditorDelegate) throws
    func editorViewForEditingNote(withUUID uuid: String, title: String, content: String, delegate: EditorDelegate) throws -> UIViewController
    func pushEditorViewController(_ destination: UIViewController, from source: UIViewController, animated: Bool)
    func quitEditorView(animated: Bool) throws
}
