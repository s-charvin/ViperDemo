import Foundation

protocol LoginViewInterface {
    var delegate: LoginViewDelegate? { get set }
    var message: String? { get set }
    var account: String? { get }
    var password: String? { get }
}
