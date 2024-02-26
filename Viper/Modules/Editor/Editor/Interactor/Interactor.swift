class EditorInteractor: ViperInteractor, EditorInteractorInterface {
    // MARK: - ViperInteractor
    weak var dataSource: EditorInteractorDataSource?
    weak var eventHandler: EditorInteractorEventHandler?

    // MARK: - EditorInteractorInput
    private var currentEditingNote: NoteModel?

    func storeCurrentEditingNote() throws {
        guard let editingNote = currentEditingNote else {
            throw NSError(domain: "EditorInteractorError", code: 1, userInfo: [NSLocalizedDescriptionKey: "There is no editing note"])
        }
        NoteDataManager.shared.storeNote(editingNote)
    }

    func currentEditingNoteTitle() -> String? {
        return currentEditingNote?.title
    }

    func currentEditingNoteContent() -> String? {
        return currentEditingNote?.content
    }

    func currentEditingNote() throws -> NoteModel? {
        guard let title = dataSource?.currentEditingNoteTitle(),
              let content = dataSource?.currentEditingNoteContent(), !(title.isEmpty && content.isEmpty) else {
            throw NSError(domain: "EditorInteractorError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Note title and content cannot be both empty"])
        }

        if currentEditingNote == nil {
            currentEditingNote = NoteModel(newNoteForTitle: title, content: content)
        } else if let uuid = currentEditingNote?.uuid {
            currentEditingNote = NoteModel(uuid: uuid, title: title, content: content)
        }

        return currentEditingNote
    }

    // MARK: - Self
    init(editingNote note: NoteModel? = nil) {
        self.currentEditingNote = note
    }

}