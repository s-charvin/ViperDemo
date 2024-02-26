import Foundation

protocol ViperPresenter {
    weak var view: ViperView? { get }
    var wireframe: ViperWireframe? { get set }
    var interactor: ViperInteractor? { get set }
}
