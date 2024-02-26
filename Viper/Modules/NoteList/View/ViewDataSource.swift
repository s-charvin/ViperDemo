import Foundation

protocol NoteListViewDataSource {
    func numberOfRowsInSection(_ section: Int) -> Int
    func textOfCellForRowAt(indexPath: IndexPath) -> String
    func detailTextOfCellForRowAt(indexPath: IndexPath) -> String
}
