import Foundation

// 错误类型定义
enum ViperAssemblyError: Error {
    case interactorEventHandlerAlreadyExists
    case interactorDataSourceAlreadyExists
    case wireframeViewAlreadyExists
    case presenterInteractorAlreadyExists
    case presenterViewAlreadyExists
    case presenterWireframeAlreadyExists
    case viewDataSourceAlreadyExists
    case viewEventHandlerAlreadyExists
}

protocol  ViperBuilder {
    // 组装VIPER模块
    static func assembleViper(
        for view: ViperView, 
        presenter: ViperPresenter, 
        interactor: ViperInteractor, 
        wireframe: ViperWireframe, 
        router: ViperRouter) throws

    func buildView(view: ViperView, presenter: ViperPresenter, interactor: ViperInteractor, wireframe: ViperWireframe, router: ViperRouter) throws
}

extension  ViperBuilder {
    // 组装VIPER模块
    static func assembleViper(
        for view: ViperView, 
        presenter: ViperPresenter, 
        interactor: ViperInteractor, 
        wireframe: ViperWireframe, 
        router: ViperRouter) throws {
        guard interactor.eventHandler == nil else {
            throw ViperAssemblyError.interactorEventHandlerAlreadyExists
        }
        guard interactor.dataSource == nil else {
            throw ViperAssemblyError.interactorDataSourceAlreadyExists
        }
        // 将 Presenter 作为 Interactor 的事件处理器和数据源
        interactor.eventHandler = presenter
        interactor.dataSource = presenter

        guard wireframe.view == nil else {
            throw ViperAssemblyError.wireframeViewAlreadyExists
        }
        // 将 View 和 Router 分别作为 Wireframe 的管理视图和路由
        wireframe.view = view
        wireframe.router = router

        guard presenter.interactor == nil else {
            throw ViperAssemblyError.presenterInteractorAlreadyExists
        }
        guard presenter.view == nil else {
            throw ViperAssemblyError.presenterViewAlreadyExists
        }
        guard presenter.wireframe == nil else {
            throw ViperAssemblyError.presenterWireframeAlreadyExists
        }
        // 将 Interactor、View 和 Wireframe 分别作为 Presenter 的交互器、视图和路由
        presenter.interactor = interactor
        presenter.view = view
        presenter.wireframe = wireframe

        guard view.viewDataSource == nil else {
            throw ViperAssemblyError.viewDataSourceAlreadyExists
        }
        view.viewDataSource = presenter

        guard view.eventHandler == nil else {
            throw ViperAssemblyError.viewEventHandlerAlreadyExists
        }
        view.eventHandler = presenter
    }
}