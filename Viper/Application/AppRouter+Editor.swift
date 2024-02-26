import UIKit

extension AppRouter {
    static func viewForCreatingNote(withDelegate delegate: EditorDelegate) -> UIViewController {
        return EditorBuilder.viewForCreatingNote(withDelegate: delegate, router: AppRouter.shared)
    }

    static func viewForEditingNote(withUUID uuid: String, title: String, content: String, delegate: EditorDelegate) -> UIViewController {
        return EditorBuilder.viewForEditingNote(withUUID: uuid, title: title, content: content, delegate: delegate, router: AppRouter())
    }
}
