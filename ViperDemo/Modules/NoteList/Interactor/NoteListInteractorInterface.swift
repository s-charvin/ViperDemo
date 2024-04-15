import Foundation

protocol NoteListInteractorInterface {
    func loadAllNotes() async
    func getNoteList() -> [NoteModel]
    func getNoteCount() -> Int
    func titleForNote(at index: UInt) -> String?
    func contentForNote(at index: UInt) -> String?

    func note(at index: UInt) -> NoteModel?
    func noteUUID(at index: UInt) -> String?
    func noteTitle(at index: UInt) -> String?
    func noteContent(at index: UInt) -> String?
    func deleteNote(at index: UInt)

    func dataDidUpdate() async
}
