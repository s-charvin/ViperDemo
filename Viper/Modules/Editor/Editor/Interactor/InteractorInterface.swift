import Foundation

enum EditorMode {
    case create, modify
}

protocol EditorInteractorInterface: AnyObject {
    func currentEditingNote() -> NoteModel?
    func storeCurrentEditingNote() throws

    func currentEditingNoteTitle() -> String?
    func currentEditingNoteContent() -> String?
}
