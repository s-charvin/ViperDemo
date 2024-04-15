import Foundation

protocol LoginServiceInterface {
    func loginedUser() -> UserModel?
    func setLoginedUser(_ user: UserModel)
    func login(withAccount account: String, password: String, success: @escaping () -> Void, error: @escaping () -> Void)
}
