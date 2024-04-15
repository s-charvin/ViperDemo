import UIKit

protocol LoginViewDelegate {
    func loginViewController(_ loginViewController: UIViewController, didLoginWithAccount account: String)
}
