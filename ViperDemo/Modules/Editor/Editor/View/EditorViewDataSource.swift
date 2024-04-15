import Foundation

protocol EditorViewDataSource: AnyObject {
    func prefixForTextView() -> String?
}
