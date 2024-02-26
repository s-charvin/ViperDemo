import Foundation




class TextWidgetInteractor: ViperInteractor, TextWidgetInteractorInterface {
    weak var dataSource: TextWidgetInteractorDataSource?
    weak var eventHandler: TextWidgetInteractorEventHandler?
    private var loginedAccount: String?

    func copyrightDescription() throws -> String {
        return "© This is TextView."
    }

    func needValidateAccount() throws -> Bool {
        return loginedAccount == nil
    }

    func didLoginedWithAccount(_ account: String) {
        self.loginedAccount = account
    }
}
