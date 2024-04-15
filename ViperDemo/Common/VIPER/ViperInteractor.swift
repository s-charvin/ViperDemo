import Foundation

protocol ViperInteractor: AnyObject {
    var dataSource: ViperPresenter? { get set } // weak
    var eventHandler: ViperPresenter? { get set } // weak
}
