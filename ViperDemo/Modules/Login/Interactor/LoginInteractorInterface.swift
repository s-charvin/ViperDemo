import Foundation

protocol LoginInteractorInterface {
    func login(withAccount account: String, password: String, success: @escaping () -> Void, error: @escaping () -> Void)
}
