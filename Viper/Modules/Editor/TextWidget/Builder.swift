import UIKit

class TextViewBuilder: ViperBuilder {
    static func view(withPrefixText prefix: String?, colorForCopyright copyrightColor: UIColor?, dataSource: TextViewDataSource?, router: ViperRouter) throws  -> UIView {
        let view = TextView()
        view.dataSource = dataSource
        view.setPrefixText(prefix)
        try buildView(view, router: router)
        return view
    }

    static func buildView(_ view: ViperView, router: ViperRouter) {
        guard let view = view as? TextView else {
            fatalError("view must be an instance of TextView")
        }
        
        let presenter = TextWidgetViewPresenter()
        let interactor = TextWidgetInteractor()
        let wireframe = TextViewWireframe()

        try assembleViper(forView: view, presenter: presenter, interactor: interactor, wireframe: wireframe, router: router)
    }
}
