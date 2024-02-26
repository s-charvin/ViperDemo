import Foundation

protocol ViperWireframe {
    weak var view: ViperView? { get }
    var router: ViperRouter? { get set }
}

