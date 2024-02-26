import Foundation

protocol TextViewDataSource {
    func prefixString(for textView: TextView) -> String?
}
