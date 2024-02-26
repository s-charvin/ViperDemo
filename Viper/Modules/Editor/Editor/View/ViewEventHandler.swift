import Foundation


protocol EditorViewEventHandler: ViperViewEventHandler {
    func didTouchNavigationBarDoneButton() throws
    var router: ViperRouter? { get }
}
