import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginViewController(_ loginViewController: UIViewController, didLoginWithAccount account: String)
}
