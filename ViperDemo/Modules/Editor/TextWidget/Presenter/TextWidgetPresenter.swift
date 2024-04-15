import Foundation
import UIKit


class TextWidgetPresenter: ViperPresenter, TextWidgetViewEventHandler {
    weak var view: ViperView?
    var interactor: ViperInteractor?
    var wireframe: ViperWireframe?

    func viperViewIsReady() {
        guard let view = self.view as? TextWidgetView,
              let interactor = self.interactor as? TextWidgetInteractor
        else { return }
        view.setPrefixText(interactor.copyrightDescription())
    }

    func loginViewController(_ loginViewController: UIViewController, didLoginWithAccount account: String) {
        guard let interactor = self.interactor as? TextWidgetInteractor
        else { return }

        interactor.didLoginedWithAccount(account)
    }
}
