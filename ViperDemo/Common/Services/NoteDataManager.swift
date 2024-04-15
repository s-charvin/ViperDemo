
import Foundation

protocol NoteDataObserver: AnyObject {
    func dataDidUpdate()
}

class NoteDataManager: NoteListDataSourceInterface, EditorDataSourceInterface {
    static let shared = NoteDataManager()
    var observers: [AnyObject] = []

    private var noteUUIDs: [String] = []
    private var notes: [String: NoteModel] = [:]

    private init() {}

    private func noteListUUIDArray() async -> Result<[String], Error> {
        do {
            let data = try Data(contentsOf: NoteDataManager.pathForNoteListUUIDsFile())
            let uuids = try JSONDecoder().decode([String].self, from: data)
            return .success(uuids)
        } catch {
            return .failure(error)
        }
    }

    private func storeNoteListUUIDs() async -> Result<Void, Error> {
        do {
            let data = try JSONEncoder().encode(Array(self.notes.keys))
            try data.write(to: NoteDataManager.pathForNoteListUUIDsFile())
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    private func localStoredNote(withUUID uuid: String) async -> Result<NoteModel, Error> {
        do {
            let data = try Data(contentsOf: NoteDataManager.pathForLocalStoredNote(withUUID: uuid))
            let note = try JSONDecoder().decode(NoteModel.self, from: data)
            return .success(note)
        } catch {
            return .failure(error)
        }
    }

    nonisolated private static func pathForNoteListUUIDsFile() -> URL {
        return self.documentsDirectory().appendingPathComponent("noteUUIDs")
    }

    nonisolated private static func pathForLocalStoreNote() -> URL {
        let notesURL = documentsDirectory().appendingPathComponent("Notes")
        if !FileManager.default.fileExists(atPath: notesURL.path) {
            do {
                try FileManager.default.createDirectory(at: notesURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                assertionFailure("Error creating directory for notes: \(error)")
            }
        }
        return notesURL
    }

    nonisolated private static func pathForLocalStoredNote(withUUID uuid: String) -> URL {
        return self.pathForLocalStoreNote().appendingPathComponent(uuid)
    }

    nonisolated private static func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

}

// MARK: - NoteListDataService
extension NoteDataManager {

    func getNotes() async -> [NoteModel] {
        Array(self.notes.values)
    }

    func setNotes(notes: [NoteModel]) async {
        self.notes = Dictionary(uniqueKeysWithValues: notes.map { ($0.uuid, $0) })
    }

    func fetchAllNotes(_ completion: @escaping (Result<[NoteModel], Error>) -> Void) async {

        if self.notes.isEmpty {
            let result = await self.noteListUUIDArray()
            switch result {
            case .success(let uuids):
                var fetchedNotes: [NoteModel] = []
                for uuid in uuids {
                    let noteResult = await localStoredNote(withUUID: uuid)
                    if case .success(let note) = noteResult {
                        fetchedNotes.append(note)
                    }
                }
                await self.setNotes(notes: fetchedNotes)
                completion(.success(fetchedNotes))
            case .failure(let error):
                completion(.failure(error))
            }

        } else {
            completion(.success(Array(self.notes.values)))
        }
    }

    func store(note: NoteModel) async -> Result<Void, Error> {

        do {
            let data = try JSONEncoder().encode(note)
            try data.write(to: NoteDataManager.pathForLocalStoredNote(withUUID: note.uuid))
            self.notes[note.uuid] = note
            let result = await self.storeNoteListUUIDs()
            if case .success = result {
                await self.notifyObservers()
            }
            return result
        } catch {
            return .failure(error)
        }
    }

    func delete(note: NoteModel) async -> Result<Void, Error> {
        do {
            try FileManager.default.removeItem(at: NoteDataManager.pathForLocalStoredNote(withUUID: note.uuid))
            self.notes.removeValue(forKey: note.uuid)
            let result = await self.storeNoteListUUIDs()
            if case .success = result {
                await self.notifyObservers()
            }
            return result
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - NoteListDataService


extension NoteDataManager {
    func addObserver(_ observer: NoteListInteractor) {
        self.observers.append(observer)
    }
//    func addObserver(_ observer: EditorInteractor) {
//        self.observers.append(observer)
//    }
    func notifyObservers() async {
        for observer in self.observers {

            if let observer = observer as? NoteListInteractor {
                await observer.dataDidUpdate()
            }
        }
    }
}
