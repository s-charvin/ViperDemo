import Foundation
import UIKit

protocol EditorDelegate: AnyObject {
    func editor(_ editor: UIViewController, didFinishEditNote note: NoteModel)
}
