import Foundation

protocol NoteListDataSourceInterface {
    func getNotes() async -> [NoteModel]
    func setNotes(notes: [NoteModel]) async

    func fetchAllNotes(_ completion: @escaping (Result<[NoteModel], Error>) -> Void) async
    func store(note: NoteModel) async -> Result<Void, Error>
    func delete(note: NoteModel) async -> Result<Void, Error>
    var observers: [AnyObject] { get set } // weak
    mutating func addObserver(_ observer: NoteListInteractor)
    func notifyObservers() async
}
