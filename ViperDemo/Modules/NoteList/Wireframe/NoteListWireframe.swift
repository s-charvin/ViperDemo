import Foundation
import UIKit

class NoteListWireframe: ViperWireframe, NoteListWireframeInterface {

    // MARK: - ViperWireframe
    weak var view: ViperView? = nil
    var router: ViperRouter? = nil

    weak var editor: UIViewController? = nil
    var presentingEditor = false
    var pushedEditor = false

    func presentLoginView(withMessage message: String, delegate: LoginViewDelegate, completion: (() -> Void)?) {
        guard let router = self.router as? NoteListRouter else { return }
        let loginViewController = router.viewForLogin(
            withMessage: message,
            delegate: delegate
        )
        type(of: router).viperPresent(
            loginViewController,
            from: self.view!.routeSource,
            animated: true,
            completion: completion)
    }

    func dismissLoginView(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        type(of: router!).viperDismiss(viewController, animated: animated, completion: completion)
    }

    func presentEditorForCreatingNewNote(withDelegate delegate: EditorDelegate, completion: (() -> Void)?) {
        guard let router = self.router as? NoteListRouter else { return }
        let editorViewController = router.viewForCreatingNote(withDelegate: delegate)
        let navigationController = UINavigationController(rootViewController: editorViewController)

        type(of: router).viperPresent(
            navigationController,
            from: self.view!.routeSource,
            animated: true,
            completion: completion
        )
        self.resetState()
        self.editor = editorViewController
        self.presentingEditor = true
    }

    func pushEditorViewForEditingNote(withUUID uuid: String, title: String, content: String, delegate: EditorDelegate) {
        guard let router = self.router as? NoteListRouter else { return }
        let editorViewController = router.viewForEditingNote(
            withUUID: uuid,
            title: title,
            content: content,
            delegate: delegate
        )

        type(of: router).viperPush(
            editorViewController,
            to: self.view!.routeSource,
            animated: true)

        self.resetState()
        self.editor = editorViewController
        self.pushedEditor = true
    }

//    func editorViewForEditingNote(withUUID uuid: String, title: String, content: String, delegate: EditorDelegate) -> UIViewController? {
//        guard let router = self.router as? NoteListRouter else { return nil }
//        return router.viewForEditingNote(
//            withUUID: uuid,
//            title: title,
//            content: content,
//            delegate: delegate
//        )
//    }

    func quitEditorView(animated: Bool) {
        guard let editor = self.editor else {
            return
        }

        guard self.presentingEditor || self.pushedEditor else {
            return
        }

        guard let router = self.router as? NoteListRouter else {
            return
        }

        if self.presentingEditor {
            self.presentingEditor = false

            type(of: router).viperDismiss(
                editor,
                animated: animated,
                completion: nil
            )

        } else if self.pushedEditor {
            self.pushedEditor = false
            let _ = type(of: router).viperPop(editor, animated: animated)
        }
    }

    func pushEditorViewController(_ destination: UIViewController, from source: UIViewController, animated: Bool) {
        guard let router = self.router as? NoteListRouter else {
            return
        }
        type(of: router).viperPush(destination, to: source, animated: true)
        self.resetState()
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
