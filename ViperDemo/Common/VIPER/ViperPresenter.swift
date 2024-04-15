import Foundation

protocol ViperPresenter: ViperViewEventHandler {
    var view: ViperView? { get set } // weak

    var wireframe: ViperWireframe? { get set }
    var interactor: ViperInteractor? { get set }
}
