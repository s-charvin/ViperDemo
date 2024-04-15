import UIKit

protocol ViperView: UIViewController {
    // 向 Presenter 提供的用于界面跳转的源界面
    var routeSource: UIViewController { get }

    // 由外部注入的视图层事件处理对象，通常是 Presenter
    var eventHandler: ViperViewEventHandler? { get set }
    // 由外部注入的视图层数据源对象，通常是 Presenter
    var viewDataSource: ViperPresenter? { get set }
}

extension ViperView {
    var routeSource : UIViewController {
        return self
    }
}
