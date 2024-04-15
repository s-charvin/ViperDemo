import Foundation


protocol EditorViewEventHandler: ViperViewEventHandler {
    func didTouchNavigationBarDoneButton() async
}
