protocol ViperViewEventHandler {
  func handleViewReady()
  func handleViewRemoved()
  func handleViewWillAppear(_ animated: Bool)
  func handleViewDidAppear(_ animated: Bool)
  func handleViewWillDisappear(_ animated: Bool)
  func handleViewDidDisappear(_ animated: Bool)
}

extension ViperViewEventHandler {
  func handleViewReady() {}
  func handleViewRemoved() {}
  func handleViewWillAppear(_ animated: Bool) {}
  func handleViewDidAppear(_ animated: Bool) {}
  func handleViewWillDisappear(_ animated: Bool) {}
  func handleViewDidDisappear(_ animated: Bool) {}
}
