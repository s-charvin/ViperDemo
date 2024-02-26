import Foundation

protocol TextWidgetInteractorInterface {
    func copyrightDescription() throws -> String
    func needValidateAccount() throws -> Bool
    func didLoginedWithAccount(_ account: String)
}
