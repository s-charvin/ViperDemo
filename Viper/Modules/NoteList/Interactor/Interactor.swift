class NoteListInteractor: ViperInteractor, NoteListInteractorInterface {
    
    // MARK: - ViperInteractor
    weak var dataSource: AnyObject?
    weak var eventHandler: AnyObject?

    // MARK: - Self
    private var currentEditingNote: NoteModel?
    private let noteListDataService: NoteListDataService

    init(noteListDataService service: NoteListDataService) {
        self.noteListDataService = service
    }

    private init() {
        fatalError("init() has not been implemented")
    }

    var noteList: [NoteModel] {
        return self.noteListDataService.noteList
    }

    // MARK: - NoteListInteractorInput

    func loadAllNotes() {
        self.noteListDataService.fetchAllNotes { notes in
            // Handle the fetched notes
        }
    }

    var noteCount: Int {
        return self.noteList.count
    }

    func titleForNote(at index: UInt) -> String? {
        guard self.noteList.count > index else { return nil }
        return self.noteList[Int(index)].title
    }

    func contentForNote(at index: UInt) -> String? {
        guard self.noteList.count > index else { return nil }
        return self.noteList[Int(index)].content
    }
    
    func note(at index: UInt) -> NoteModel? {
        guard self.noteList.count > index else { return nil }
        return self.noteList[Int(index)]
    }

    func noteUUID(at index: UInt) -> String? {
        guard self.noteList.count > index else { return nil }
        return self.noteList[Int(index)].uuid
    }

    func noteTitle(at index: UInt) -> String? {
        guard self.noteList.count > index else { return nil }
        return self.noteList[Int(index)].title
    }

    func noteContent(at index: UInt) -> String? {
        guard self.noteList.count > index else { return nil }
        return self.noteList[Int(index)].content
    }

    func deleteNote(at index: UInt) {
        guard self.noteList.count > index else { return }
        let note = noteList[Int(index)]
        self.noteListDataService.deleteNote(note)
    }
}