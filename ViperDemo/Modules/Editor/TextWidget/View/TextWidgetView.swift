import UIKit

class TextWidgetView: UIViewController, ViperView,
                TextWidgetViewInterface {

    var eventHandler: ViperViewEventHandler?
    var viewDataSource: ViperPresenter?

    var colorForCopyright: UIColor = .black
    var textView: UITextView = UITextView()
    private var appeared: Bool = false
    private var ready: Bool = false
    private var prefix: String? = ""

    var dataSource: TextWidgetViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: view.topAnchor),
            self.textView.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.textView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sendViewReadyEventIfNeeded()
        self.eventHandler?.viperViewWillAppear(animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.eventHandler?.viperViewDidAppear(animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.eventHandler?.viperViewWillDisappear(animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.eventHandler?.viperViewDidDisappear(animated: false)
        self.ready = false
    }

    private func sendViewReadyEventIfNeeded() {
        if !self.ready, let handler = self.eventHandler {
            self.ready = true
            handler.viperViewIsReady()
        }
    }

    func setPrefixText(_ prefix: String) {
        let text = self.textView.text
        self.prefix = prefix
        if let text = text {
            self.textView.text = text
        }
    }

    var text: String? {
        get {
            guard let text = self.textView.text, let prefix = self.prefix else {
                return self.textView.text
            }
            return String(text.dropFirst(prefix.count + 1))
        }
        set {

            if let prefix = prefix, let newValue = newValue {
                let newText = "\(prefix)\n\(newValue)"
                let attributedString = NSMutableAttributedString(string: newText)
                let color = colorForCopyright 

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.paragraphSpacing = 12
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: newText.count))

                attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: prefix.count))
                textView.attributedText = attributedString
            } else {
                textView.text = newValue
            }
        }
    }






}
