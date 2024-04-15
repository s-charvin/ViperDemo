import Foundation

protocol NoteListViewDataSource {
    func numberOfRowsInSection(_ section: Int) async -> Int
    func textOfCellForRowAt(indexPath: IndexPath) async -> String
    func detailTextOfCellForRowAt(indexPath: IndexPath) async -> String
}
