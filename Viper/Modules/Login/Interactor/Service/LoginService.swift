import Foundation

class LoginService {
    static let shared = LoginService()

    private init() {}

    func loginedUser() -> UserModel? {
        let userDefaults = UserDefaults.standard
        guard let account = userDefaults.string(forKey: "account"),
              let password = userDefaults.string(forKey: "password") else {
            return nil
        }
        return UserModel(account: account, password: password)
    }

    func setLoginedUser(_ user: UserModel) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(user.account, forKey: "account")
        userDefaults.set(user.password, forKey: "password")
        userDefaults.synchronize()
    }

    func login(withAccount account: String, password: String, success: @escaping () -> Void, error: @escaping () -> Void) {
        if account == "abc" && password == "123" {
            let user = UserModel(account: account, password: password)
            self.setLoginedUser(user)
            DispatchQueue.main.async {
                success()
            }
        } else {
            DispatchQueue.main.async {
                error()
            }
        }
    }
}
