import Foundation
import UIKit

protocol NoteListViewEventHandler: ViperViewEventHandler {
    func didTouchNavigationBarAddButton()
    func canEditRow(at indexPath: IndexPath) -> Bool
    func handleDeleteCellForRow(at indexPath: IndexPath)  async
    func handleDidSelectRow(at indexPath: IndexPath)  async
}
