import UIKit

class EditorViewController: UIViewController, ViperView, 
                                EditorViewInterface,
                            TextWidgetViewDataSource {

    var eventHandler: ViperViewEventHandler? = nil
    var viewDataSource: ViperPresenter? = nil

    private var appeared = false
    // lazy var titleTextField: UITextField
    // lazy var contentTextView: TextView

    weak var delegate: EditorDelegate?
    var editMode: EditorMode = .create

    var editorTitle: String? {
        return self.titleTextField.text
    }
    
    var content: String? {
        return self.contentTextView.text
    }
    
    func updateTitle(_ title: String) {
        self.titleTextField.text = title
    }
    
    func updateContent(_ content: String) {
        self.contentTextView.text = content
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Editor"
        self.initUI()
    }

    private func initUI() {
        self.view.addSubview(self.titleTextField)
        self.view.addSubview(self.contentTextView.view)

        NSLayoutConstraint.activate([
            self.titleTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.titleTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.titleTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.titleTextField.heightAnchor.constraint(equalToConstant: 40),

            self.contentTextView.view.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor, constant: 20),
            self.contentTextView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentTextView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.contentTextView.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.appeared {
            let addNoteItem = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self.eventHandler,
                action: #selector(self.didTouchNavigationBarDoneButton)
            )
            self.navigationItem.rightBarButtonItem = addNoteItem
            
            self.eventHandler?.viperViewIsReady()
            self.appeared = true
        }
        self.eventHandler?.viperViewWillAppear(animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.eventHandler?.viperViewDidAppear(animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.eventHandler?.viperViewWillDisappear(animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.eventHandler?.viperViewDidDisappear(animated: animated)
        if self.isRemoving() {
            self.eventHandler?.viperViewWasRemoved()
        }
    }

    // MARK: - TextViewDataSource
    
    func prefix(for textView: TextWidgetView) -> String? {
        guard let viewDataSource = self.viewDataSource as? EditorViewDataSource
        else { return nil }
        return viewDataSource.prefixForTextView()
    }

    @objc func didTouchNavigationBarDoneButton() async {
        guard let eventHandler = self.eventHandler as? EditorViewEventHandler
        else { return }
        await eventHandler.didTouchNavigationBarDoneButton()
    }

    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .natural
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var contentTextView: TextWidgetView = {
        var textView: TextWidgetView = TextWidgetBuilder.getView() as! TextWidgetView
        textView.textView.backgroundColor = UIColor(red: 0.7837572459, green: 0.9330496704, blue: 1, alpha: 1)
        textView.textView.font = UIFont.systemFont(ofSize: 14)
        textView.textView.translatesAutoresizingMaskIntoConstraints = false
        textView.dataSource = self
        textView.colorForCopyright = UIColor.gray
        return textView
    }()
}
