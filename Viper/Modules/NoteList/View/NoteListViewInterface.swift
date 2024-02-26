import Foundation
import UIKit

protocol NoteListViewInterface: AnyObject {
    func noteListTableView() -> UITableView
    func cellForRowAt(_ indexPath: IndexPath, text: String, detailText: String) -> UITableViewCell
}
