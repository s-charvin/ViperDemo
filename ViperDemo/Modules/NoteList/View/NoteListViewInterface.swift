import Foundation
import UIKit

protocol NoteListViewInterface {
    var noteListTableView: UITableView { get }
    func cellForRowAt(_ indexPath: IndexPath, text: String, detailText: String) -> UITableViewCell
}
