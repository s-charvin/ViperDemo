import Foundation
import UIKit

protocol TextWidgetViewInterface {
    var dataSource: TextViewDataSource? { get set }
    var colorForCopyright: UIColor? { get set }
    func setPrefixText(_ prefix: String?)
}
