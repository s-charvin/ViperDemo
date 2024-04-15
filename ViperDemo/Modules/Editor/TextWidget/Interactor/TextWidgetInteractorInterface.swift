import Foundation

protocol TextWidgetInteractorInterface {
    func copyrightDescription() -> String
    func needValidateAccount() -> Bool
    func didLoginedWithAccount(_ account: String)
}
