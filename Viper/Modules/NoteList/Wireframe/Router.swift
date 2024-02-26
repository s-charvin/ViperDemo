import Foundation
import UIKit

protocol NoteListRouter: ViperRouter {
    static func viewForLogin(withMessage message: String, delegate: LoginViewDelegate) throws -> UIViewController
    static func viewForCreatingNote(withDelegate delegate: EditorDelegate) throws -> UIViewController
    static func viewForEditingNote(withUUID uuid: String, title: String, content: String, delegate: EditorDelegate) throws -> UIViewController
}
