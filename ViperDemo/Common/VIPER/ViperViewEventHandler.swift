protocol ViperViewEventHandler: AnyObject {
    func viperViewIsReady()
    func viperViewWasRemoved()
    func viperViewWillAppear(animated: Bool)
    func viperViewDidAppear(animated: Bool)
    func viperViewWillDisappear(animated: Bool)
    func viperViewDidDisappear(animated: Bool)
}

extension ViperViewEventHandler {
    func viperViewIsReady() {}
    func viperViewWasRemoved() {}
    func viperViewWillAppear(animated: Bool) {}
    func viperViewDidAppear(animated: Bool) {}
    func viperViewWillDisappear(animated: Bool) {}
    func viperViewDidDisappear(animated: Bool) {}
}
