import Foundation

protocol EditorInteractorDataSource: AnyObject {
    func currentEditingNoteTitle() -> String?
    func currentEditingNoteContent() -> String?
}
