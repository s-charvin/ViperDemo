class EditorInteractor: ViperInteractor, EditorInteractorInterface {

    weak var dataSource: ViperPresenter? = nil
    weak var eventHandler: ViperPresenter? = nil

    // MARK: - EditorInteractorInput
    var editingNote: NoteModel? = nil
    var noteDataService: EditorDataSourceInterface? = nil

    func storeCurrentEditingNote() async {
        guard let editingNote = self.editingNote else {
            return
        }
        let _ = await self.noteDataService!.store(note: editingNote)
    }

    func currentEditingNoteTitle() -> String? {
        return self.editingNote?.title
    }

    func currentEditingNoteContent() -> String? {
        return self.editingNote?.content
    }

    func currentEditingNote() -> NoteModel? {

        guard let dataSource = dataSource as? EditorViewPresenter else {
            return nil
        }

        guard let title = dataSource.currentEditingNoteTitle(),
              let content = dataSource.currentEditingNoteContent(), 
              !(title.isEmpty && content.isEmpty) else {
            return nil
        }

        if self.editingNote == nil {
            self.editingNote = NoteModel(title: title, content: content)
        } else if let uuid = self.editingNote?.uuid {
            self.editingNote = NoteModel(uuid: uuid, title: title, content: content)
        }
        return self.editingNote
    }
}
