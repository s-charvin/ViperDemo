
import Foundation

class NoteDataManager: NoteListDataService {
    // MARK: - Self
    static let shared = NoteDataManager()

    private var noteUUIDs: [String] = []
    private var notes: [NoteModel] = []

    // MARK: - NoteListDataService
    var noteList: [NoteModel] {
        return notes
    }

    func fetchAllNotes(completion: (([NoteModel]) -> Void) = { _ in }) {
        DispatchQueue.main.async {
            if self.notes.isEmpty {
                self.noteUUIDs = []
                self.notes = []
                let uuids = self.noteListUUIDArray()
                var fetchedNotes: [NoteModel] = []
                for uuid in uuids {
                    if let note = self.localStoredNote(withUUID: uuid) {
                        fetchedNotes.append(note)
                    }
                }
                self.noteUUIDs.append(contentsOf: uuids)
                self.notes.append(contentsOf: fetchedNotes)
            }
            completion(self.notes)
        }
    }
    
    func store(note: NoteModel) {
        DispatchQueue.main.async {
            // /Notes/uuid
            let filePath = NoteDataManager.pathForLocalStoredNote(withUUID: note.uuid)
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: note, requiringSecureCoding: false)
                try data.write(to: URL(fileURLWithPath: filePath))
                if !self.noteUUIDs.contains(note.uuid) {
                    self.noteUUIDs.append(note.uuid)
                    self.notes.append(note)
                    self.storeNoteListUUIDs()
                } else {
                    if let idx = self.notes.firstIndex(where: { $0.uuid == note.uuid }) {
                        self.notes[idx] = note
                    }
                }
            } catch {
                print("Error storing note: \(error)")
            }
        }
    }
    
    func delete(note: NoteModel) {
        DispatchQueue.main.async {
            guard self.noteUUIDs.contains(note.uuid) else {
                print("Note to delete does not exist")
                return
            }
            self.noteUUIDs.removeAll { $0 == note.uuid }
            self.storeNoteListUUIDs()
            if let idx = self.notes.firstIndex(where: { $0.uuid == note.uuid }) {
                self.notes.remove(at: idx)
                // /Notes/uuid
                let filePath = NoteDataManager.pathForLocalStoredNote(withUUID: note.uuid)
                do {
                    try FileManager.default.removeItem(atPath: filePath)
                } catch {
                    print("Error deleting note: \(error)")
                }
            }
        }
    }
    

    private init() {}

    private func noteListUUIDArray() -> [String] {
        // /noteUUIDs
        let filePath = NoteDataManager.pathForNoteListUUIDsFile()
        if let uuids = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [String] {
            return uuids
        }
        return []
    }
    
    private func storeNoteListUUIDs() {
        // /noteUUIDs
        let filePath = NoteDataManager.pathForNoteListUUIDsFile()
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.noteUUIDs, requiringSecureCoding: false)
            try data.write(to: URL(fileURLWithPath: filePath))
        } catch {
            print("Error storing note list UUIDs: \(error)")
        }
    }
    
    private func localStoredNote(withUUID uuid: String) -> NoteModel? {
        // /Notes/uuid
        let filePath = NoteDataManager.pathForLocalStoredNote(withUUID: uuid)
        if let note = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? NoteModel {
            return note
        }
        return nil
    }
    
    private static func pathForNoteListUUIDsFile() -> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return documentsDirectory.appending("/noteUUIDs")
    }
    
    private static func pathForLocalStoreNote() -> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documentsDirectory.appending("/Notes")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory for notes: \(error)")
            }
        }
        return path
    }
    
    private static func pathForLocalStoredNote(withUUID uuid: String) -> String {
        return pathForLocalStoreNote().appending("/\(uuid)")
    }
}