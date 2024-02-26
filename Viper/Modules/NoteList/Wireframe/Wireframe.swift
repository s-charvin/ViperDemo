import Foundation
import UIKit

class NoteListWireframe: ViperWireframe, NoteListWireframeInterface {
    // MARK: - ViperWireframe
    weak var view: ViperView?
    var router: NoteListRouter?

    // MARK: - Self
    weak var editor: UIViewController?
    var presentingEditor = false
    var pushedEditor = false

    func presentLoginView(withMessage message: String, delegate: LoginViewDelegate, completion: (() -> Void)?) {
        guard let loginViewController = type(of: router!).viewForLogin(withMessage: message, delegate: delegate) else { return }
        type(of: router!).presentViewController(loginViewController, to: self.view!.routeSource, animated: true, completion: completion)
    }

    func dismissLoginView(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        viewController.dismiss(animated: animated, completion: completion)
    }

    func presentEditorForCreatingNewNote(withDelegate delegate: EditorDelegate, completion: (() -> Void)?) {
        guard let editorViewController = type(of: router!).viewForCreatingNote(withDelegate: delegate) else { return }
        let navigationController = UINavigationController(rootViewController: editorViewController)
        type(of: router!).presentViewController(navigationController, to: self.view!.routeSource, animated: true, completion: completion)
        resetState()
        self.editor = editorViewController
        self.presentingEditor = true
    }

    func pushEditorViewForEditingNote(withUUID uuid: String, title: String, content: String, delegate: EditorDelegate) {
        guard let editorViewController = type(of: router!).viewForEditingNote(withUUID: uuid, title: title, content: content, delegate: delegate) else { return }
        type(of: router!).pushViewController(editorViewController, to: self.view!.routeSource, animated: true)
        resetState()
        self.editor = editorViewController
        self.pushedEditor = true
    }

    func editorViewForEditingNote(withUUID uuid: String, title: String, content: String, delegate: EditorDelegate) -> UIViewController? {
        return type(of: router!).viewForEditingNote(withUUID: uuid, title: title, content: content, delegate: delegate)
    }

    func quitEditorView(animated: Bool) throws {
        guard let editor = self.editor else {
            throw EditorError.noEditorPresented
        }

        guard self.presentingEditor || self.pushedEditor else {
            throw EditorError.editorNotPresentedOrPushed
        }

        if self.presentingEditor {
            self.presentingEditor = false
            type(of: router!).dismissViewController(editor, animated: animated, completion: nil)
        } else if self.pushedEditor {
            self.pushedEditor = false
            type(of: router!).popViewController(editor, animated: animated)
        }
    }

    func pushEditorViewController(_ destination: UIViewController, from source: UIViewController, animated: Bool) {
        type(of: router!).pushViewController(destination, to: source, animated: true)
        resetState()
        self.editor = destination
        self.pushedEditor = true
    }

    private func resetState() {
        self.editor = nil
        self.presentingEditor = false
        self.pushedEditor = false
    }

    enum EditorError: Error {
        case noEditorPresented
        case editorNotPresentedOrPushed
    }

}
