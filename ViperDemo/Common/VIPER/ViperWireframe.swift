import Foundation

protocol ViperWireframe: AnyObject {
    var view: ViperView? { get set } // weak
    var router: ViperRouter? { get set }
}

