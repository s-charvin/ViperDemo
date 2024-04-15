import Foundation

protocol EditorDataSourceInterface {
    func store(note: NoteModel) async -> Result<Void, Error>
    func delete(note: NoteModel) async -> Result<Void, Error>
//    var observers: [AnyObject] { get set } // weak
//    mutating func addObserver(_ observer: EditorInteractor)
//    func notifyObservers() async
}
