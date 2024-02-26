import Foundation

protocol NoteListInteractorInterface {
    func loadAllNotes()
    var noteCount: Int { get }
    func titleForNote(at index: UInt) -> String?
    func contentForNote(at index: UInt) -> String?

    func note(at index: UInt) -> NoteModel?
    func noteUUID(at index: UInt) -> String?
    func noteTitle(at index: UInt) -> String?
    func noteContent(at index: UInt) -> String?
    func deleteNote(at index: UInt)
}