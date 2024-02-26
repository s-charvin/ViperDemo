import Foundation


class TextWidgetViewPresenter: ViperPresenter, TextWidgetViewEventHandler {
    var wireframe: ViperWireframe?
    weak var view: TextWidgetViewInterface?
    var interactor: TextWidgetInteractorInterface?

    func handleViewReady() throws {
        guard let view = view, 
              let interactor = interactor else {
            throw NSError(domain: "View or Interactor not ready", code: 0, userInfo: nil)
        }
        view.setPrefixText(try interactor.copyrightDescription())
    }

    // func handleViewWillAppear(_ animated: Bool) {
        
    // }

    // func handleViewDidAppear(_ animated: Bool) {
        
    // } 

    // func handleViewWillDisappear(_ animated: Bool) {
        
    // }

    // func handleViewDidDisappear(_ animated: Bool) {
        
    // }

    // func handleViewRemoved() {
        
    // }

    func loginViewController(_ loginViewController: UIViewController, didLoginWithAccount account: String) {
        interactor?.didLoginedWithAccount(account)
    }
}
