import Foundation
import UIKit

protocol NoteListViewEventHandler: ViperViewEventHandler, UIViewControllerPreviewingDelegate {
    func didTouchNavigationBarAddButton()
    func canEditRowAt(indexPath: IndexPath) -> Bool
    func handleDeleteCellForRowAt(indexPath: IndexPath)
    func handleDidSelectRowAt(indexPath: IndexPath)
}
