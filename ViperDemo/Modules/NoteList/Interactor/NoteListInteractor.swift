import Combine
import Foundation

class NoteListInteractor: ViperInteractor, NoteListInteractorInterface {

    var dataSource: ViperPresenter? = nil
    var eventHandler: ViperPresenter? = nil

    var noteListDataService: NoteListDataSourceInterface? = nil

    private var cachedNotes: [NoteModel]? = nil
    private var currentEditingNote: NoteModel? = nil
//    private var refreshTimer: AnyCancellable?

    init() {
//        self.refreshTimer = Timer.publish(
//            every: 300,
//            on: .main,
//            in: .common
//        ).autoconnect().sink { _ in
//            Task.init {
//                await self.dataDidUpdate()
//            }
//        }
    }
    func loadAllNotes() async {
        guard let noteListDataService = self.noteListDataService else { return }

        await noteListDataService.fetchAllNotes() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notes):
                self.cachedNotes = notes
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func dataDidUpdate() async {
        guard let noteListDataService = self.noteListDataService else { return }
        let notes = await noteListDataService.getNotes()
        self.cachedNotes = notes
    }

    // MARK: - NoteListInteractorInterface

    func getNoteList() -> [NoteModel] {
        if let cached = self.cachedNotes {
            return cached
        }
        return []
    }

    func getNoteCount() -> Int {
        if let cached = self.cachedNotes {
            return cached.count
        }
        return 0
    }

    func titleForNote(at index: UInt) -> String? {
        if let cached = self.cachedNotes {
            guard cached.count > index else { return nil }
            return cached[Int(index)].title
        }
        return nil
    }

    func contentForNote(at index: UInt) -> String? {
        if let cached = self.cachedNotes {
            guard cached.count > index else { return nil }
            return cached[Int(index)].content
        }
        return nil
    }

    func note(at index: UInt) -> NoteModel? {
        if let cached = self.cachedNotes {
            guard cached.count > index else { return nil }
            return cached[Int(index)]
        }
        return nil
    }

    func noteUUID(at index: UInt) -> String? {
        if let cached = self.cachedNotes {
            guard cached.count > index else { return nil }
            return cached[Int(index)].uuid
        }
        return nil
    }

    func noteTitle(at index: UInt) -> String? {
        if let cached = self.cachedNotes {
            guard cached.count > index else { return nil }
            return cached[Int(index)].title
        }
        return nil
    }

    func noteContent(at index: UInt) -> String? {
        if let cached = self.cachedNotes {
            guard cached.count > index else { return nil }
            return cached[Int(index)].content
        }
        return nil
    }

    func deleteNote(at index: UInt) {
        guard self.cachedNotes?.count ?? 0 > index, let noteListDataService = self.noteListDataService else { return }
        let note = self.cachedNotes![Int(index)]

        // 异步删除函数
        Task.init {
            await noteListDataService.delete(note: note)
        }

        // 更新数据
        self.cachedNotes?.remove(at: Int(index))
        

    }
}
