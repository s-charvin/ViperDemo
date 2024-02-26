import Foundation

protocol LoginViewInterface: AnyObject {
    var delegate: LoginViewDelegate? { get set }
    var message: String? { get set }
    func account() -> String?
    func password() -> String?
}
