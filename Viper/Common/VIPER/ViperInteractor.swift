import Foundation

protocol ViperInteractor {
    weak var dataSource: AnyObject? { get }
    weak var eventHandler: AnyObject? { get }
}