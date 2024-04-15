import Foundation

enum EditorMode {
    case create, modify
}

protocol EditorInteractorInterface: AnyObject {
    func currentEditingNote() -> NoteModel?
    func storeCurrentEditingNote() async

    func currentEditingNoteTitle() -> String?
    func currentEditingNoteContent() -> String?
}
