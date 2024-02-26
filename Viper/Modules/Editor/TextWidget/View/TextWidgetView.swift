import UIKit

class TextView: ViperView, TextWidgetViewInterface, UITextView {
    
    // MARK: - ViperView
    var eventHandler: TextWidgetViewEventHandler?
    weak var dataSource: TextViewDataSource?
    // var routeSource: UIViewController?

    // MARK: - Self
    private var prefix: String?
    private var appeared = false
    private var ready = false

    // MARK: - TextWidgetViewInterface
    // var dataSource: TextViewDataSource?
    func setPrefixText(prefix: String) {
        let text = self.text
        self.prefix = prefix
        if text != nil {
            self.text = text
        }
    }

    var prefixText: String? {
        if let dataSource = self.dataSource as? TextViewDataSource,
           let addition = dataSource.prefixString(forTextView: self) {
            return prefix.flatMap { $0 + addition }
        }
        return prefix
    }


    private func sendViewReadyEventIfNeeded() {
        guard !ready, eventHandler != nil else { return }
        ready = true
        eventHandler?.handleViewReady()
    }

    // MARK: - UITextView
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            sendViewReadyEventIfNeeded()
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview == nil {
            eventHandler?.handleViewRemoved()
            ready = false
        }
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if let newWindow = newWindow {
            sendViewReadyEventIfNeeded()
            eventHandler?.handleViewWillAppear(animated: false)
        } else {
            eventHandler?.handleViewWillDisappear(animated: false)
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            sendViewReadyEventIfNeeded()
            eventHandler?.handleViewDidAppear?(animated: false)
        } else {
            eventHandler?.handleViewDidDisappear?(animated: false)
        }
    }

    override var text: String? {
        get {
            guard let text = super.text, let prefix = self.prefixText else {
                return super.text
            }
            return String(text.dropFirst(prefix.count + 1))
        }
        set {
            guard let newText = newValue, let prefix = self.prefixText else {
                super.text = newValue
                return
            }
            let fullText = "\(prefix)\n\(newText)"
            let attributedString = NSMutableAttributedString(string: fullText)
            let colorForCopyright = self.colorForCopyright ?? .black
            attributedString.addAttribute(.foregroundColor, value: colorForCopyright, range: NSRange(location: 0, length: prefix.count))
            self.attributedText = attributedString
        }
    }
}
