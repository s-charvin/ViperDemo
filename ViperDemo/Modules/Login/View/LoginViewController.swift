import UIKit

class LoginViewController: UIViewController, ViperView,
                            LoginViewInterface {
    var eventHandler: ViperViewEventHandler? = nil
    var viewDataSource: ViperPresenter? = nil

    private var appeared = false
    // lazy var accountTextField
    // lazy var passwordTextField
    // lazy var messageLabel
    // lazy var loginButton

    // MARK: - LoginViewInterface
    var delegate: LoginViewDelegate?

    var message: String? {
        didSet {
            self.messageLabel.text = message
        }
    }

    var account:String? {
        self.accountTextField.text
    }

    var password: String? {
        self.passwordTextField.text
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }

    func initUI() {
        self.view.backgroundColor = .white


        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.accountTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.loginButton)

       // Disable autoresizing masks
        [self.messageLabel, self.accountTextField, self.passwordTextField, self.loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Constraints for messageLabel
        NSLayoutConstraint.activate([
            self.messageLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 106.5),
            self.messageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.messageLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.messageLabel.heightAnchor.constraint(equalToConstant: 20.5)
        ])

        // Constraints for accountTextField
        NSLayoutConstraint.activate([
            self.accountTextField.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 45.5),
            self.accountTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 94),
            self.accountTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -94),
            self.accountTextField.heightAnchor.constraint(equalToConstant: 30)
        ])

        // Constraints for passwordTextField
        NSLayoutConstraint.activate([
            self.passwordTextField.topAnchor.constraint(equalTo: self.accountTextField.bottomAnchor, constant: 20),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.accountTextField.leadingAnchor),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.accountTextField.trailingAnchor),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 30)
        ])

        // Constraints for loginButton
        NSLayoutConstraint.activate([
            self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 50),
            self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loginButton.widthAnchor.constraint(equalToConstant: 160),
            self.loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.appeared {
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

    @objc private func startLogin(_ sender: UIButton) {
        guard let eventHandler = self.eventHandler as? LoginViewEventHandler else {
            return
        }
        eventHandler.didTouchLoginButton()
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
        label.text = self.message
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login in", for: .normal)
        button.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 1, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(self.startLogin(_:)), for: .touchUpInside)
        return button
    }()
}
