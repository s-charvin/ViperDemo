import Foundation

protocol TextWidgetViewDataSource {
    func prefix(for textView: TextWidgetView) -> String?
}
