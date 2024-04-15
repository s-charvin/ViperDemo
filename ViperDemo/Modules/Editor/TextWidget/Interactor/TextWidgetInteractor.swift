import Foundation




class TextWidgetInteractor: ViperInteractor, TextWidgetInteractorInterface {
    weak var dataSource: ViperPresenter?
    weak var eventHandler: ViperPresenter?

    private var loginedAccount: String?

    func copyrightDescription() -> String {
        return "© This is TextView."
    }

    func needValidateAccount() -> Bool {
        return loginedAccount == nil
    }

    func didLoginedWithAccount(_ account: String) {
        self.loginedAccount = account
    }
}
