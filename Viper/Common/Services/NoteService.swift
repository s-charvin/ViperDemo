import Foundation

protocol NoteListDataService {
    var noteList: [NoteModel] { get }
    
    func fetchAllNotes(with completion: ([NoteModel]) -> Void) throws
    func store(note: NoteModel) throws
    func delete(note: NoteModel) throws
}

