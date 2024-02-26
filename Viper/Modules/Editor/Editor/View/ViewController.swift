import UIKit

class EditorViewController: ViperView, EditorViewInterface, TextViewDataSource, UIViewController {
    // MARK: - ViperView
    var eventHandler: EditorViewEventHandler
    var viewDataSource: EditorViewDataSource

    // MARK: - Self
    private var appeared = false
    // lazy var titleTextField: UITextField
    // lazy var contentTextView: TextView



    // MARK: - EditorViewInterface
    weak var delegate: EditorDelegate?
    var editMode: EditorMode = .unknown
    
    var titleString: String? {
        return titleTextField.text
    }
    
    var contentString: String? {
        return contentTextView.text
    }
    
    func updateTitleString(_ title: String) {
        titleTextField.text = title
    }
    
    func updateContentString(_ content: String) {
        contentTextView.text = content
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Editor"
        initUI()
    }

    private func initUI() {
        self.view.addSubview(titleTextField)
        self.view.addSubview(contentTextView)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !appeared {
            
            let addNoteItem = UIBarButtonItem(barButtonSystemItem: .done, target: eventHandler, action: #selector(EditorViewEventHandler.didTouchNavigationBarDoneButton))
            self.navigationItem.rightBarButtonItem = addNoteItem
            
            eventHandler?.handleViewReady()
            appeared = true
        }
        eventHandler?.handleViewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventHandler?.handleViewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.handleViewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        eventHandler?.handleViewDidDisappear(animated)
        if self.isRemoving() {
            eventHandler?.handleViewRemoved()
        }
    }

    // MARK: - TextViewDataSource
    func prefixStringForTextView(_ textView: TextView) -> String {
        return viewDataSource?.prefixStringForTextView()
    }
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .natural
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var contentTextView: TextView = {
        var textView: TextView = TextView()
        TextViewBuilder.buildView(textView, router: eventHandler?.router)
        textView.backgroundColor = UIColor(red: 0.7837572459, green: 0.9330496704, blue: 1, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.dataSource = self
        textView.copyrightColor = UIColor.gray
        return textView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
