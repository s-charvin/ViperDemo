import UIKit

class LoginViewController: ViperView, LoginViewInterface , UIViewController{

    // MARK: - Self
    private var appeared = false
    // lazy var accountTextField
    // lazy var passwordTextField
    // lazy var messageLabel
    // lazy var loginButton


    // MARK: - ViperView
    private var eventHandler: LoginViewEventHandler?
    private var viewDataSource: Any?

    // MARK: - LoginViewInterface
    weak var delegate: LoginViewDelegate?
    var message: String? {
        didSet {
            messageLabel?.text = message
        }
    }

    func account() -> String? {
        accountTextField.text
    }

    func password() -> String? {
        passwordTextField.text
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }

    func initUI() {
        view.addSubview(messageLabel)
        view.addSubview(accountTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)

        view.backgroundColor = .white
        
       // Disable autoresizing masks
        [messageLabel, accountTextField, passwordTextField, loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Constraints for messageLabel
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 106.5),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            messageLabel.heightAnchor.constraint(equalToConstant: 20.5)
        ])

        // Constraints for accountTextField
        NSLayoutConstraint.activate([
            accountTextField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 45.5),
            accountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 94),
            accountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -94),
            accountTextField.heightAnchor.constraint(equalToConstant: 30)
        ])

        // Constraints for passwordTextField
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: accountTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: accountTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: accountTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30)
        ])

        // Constraints for loginButton
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 160),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !appeared {
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

    @objc private func startLogin(_ sender: UIButton) {
        eventHandler?.didTouchLoginButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: - UI Components
    private lazy var accountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Account"
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = message
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login in", for: .normal)
        button.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 1, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(startLogin(_:)), for: .touchUpInside)
        return button
    }()


}
