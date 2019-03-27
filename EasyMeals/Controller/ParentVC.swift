
import UIKit
import SVProgressHUD

@objc protocol ParentVCDelegate {
    func controllerStartProcessing(withStatus status: String?)
    func controllerStopProcessing()
    func getVC() -> UIViewController
    func controllerPerformSegue(withIdentifier identifier: String, item: Any?)
    func refreshControlEndRefreshing()
    
}

class ParentVC: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    
    weak var activeTextField: UITextField?
    weak var activeTextView: UITextView?
    
    var isProcessing : Bool?
    var isKeyboardShown : Bool?
    
    var refreshControl = UIRefreshControl()
    
    var curScrollOffset = CGPoint()
    var curViewBotConstant = CGFloat()
    var kbSizeHeight = CGFloat()
    
    // MARK: - Override properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView?.delegate = self
        scrollView?.keyboardDismissMode = .interactive
        activeTextField = nil
        activeTextView = nil
        isKeyboardShown = false
        isProcessing = false
        refreshControl.tintColor = UIColor.black
        
        self.hideKeyboardWhenTappedAround()
        self.registerForKeyboardNotifications()
        
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    // MARK: View Controller Helping Functions
    
    func showSuccess(withStatus status:String? = nil) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: status)
        }
        enableUserInteraction()
    }
    
    func showError(withStatus status:String? = nil) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: status)
        }
        enableUserInteraction()
    }
    
    func startProcessing(withStatus status: String? = nil, disableUserInteraction interactionDisabled: Bool = true){
        isProcessing = true
        if interactionDisabled {
            disableUserInteraction()
        } else {
            enableUserInteraction()
        }
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: status)
        }
        
    }
    
    func stopProcessing(){
        isProcessing = false
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
        enableUserInteraction()
    }
    
    func disableUserInteraction() {
        self.view.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    func enableUserInteraction() {
        self.view.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    func startRefreshControllerProcessing() {
        isProcessing = true
        self.view.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        
    }
    
    func stopRefreshControllerProcessing() {
        isProcessing = false
        self.view.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        refreshControl.endRefreshing()
        
    }
    
    func onParentRoot(animated: Bool = true){
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    func onParentBack(animated: Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }
    
    func onParentDismiss(animated: Bool = true){
        self.dismiss(animated: animated, completion: nil);
    }
    
    // MARK: Keyboard Handeling
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    @objc func kbDidChangeFrame(_ notification:Notification) {
        guard isKeyboardShown == true else { return }
        
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        kbSizeHeight = kbFrameSize.height
        if viewBottomConstraint != nil  {
            viewBottomConstraint.constant = kbFrameSize.height + curViewBotConstant
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    @objc func kbWillShow(_ notification:Notification) {
        guard isKeyboardShown == false else { return }
        
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        kbSizeHeight = kbFrameSize.height
        if let constraint = viewBottomConstraint {
            curViewBotConstant = constraint.constant
            constraint.constant = kbFrameSize.height + curViewBotConstant// + 20
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        if let scroll = scrollView  {
            curScrollOffset = scroll.contentOffset
            UIView.animate(withDuration: 0.3) {
                scroll.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
            }
        }
        
        self.isKeyboardShown = true
        
    }
    
    @objc func kbWillHide() {
        self.isKeyboardShown = false
        
        if let scroll = scrollView {
            curScrollOffset = CGPoint.zero
            scroll.contentOffset = curScrollOffset
        }
        
        if let constraint = viewBottomConstraint {
            constraint.constant = curViewBotConstant// - 20
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            self.curViewBotConstant = 0.0
            
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

// MARK: - TextField Delegate

extension ParentVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

// MARK: - TextView Delegate

extension ParentVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
}

// MARK: - ScrollView Delegate

//extension ParentVC: UIScrollViewDelegate {
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        activeTextField?.resignFirstResponder()
//        activeTextView?.resignFirstResponder()
//    }
//
//}

// MARK: - ParentVC Delegate

extension ParentVC: ParentVCDelegate {
    
    func controllerStartProcessing(withStatus status: String?) {
        self.startProcessing(withStatus: status)
    }
    
    func controllerStopProcessing() {
        self.stopProcessing()
    }
    
    func getVC() -> UIViewController {
        return self
    }
    
    func controllerPerformSegue(withIdentifier identifier: String, item: Any?) {
        self.performSegue(withIdentifier: identifier, sender: item)
    }
    
    func refreshControlEndRefreshing() {
        refreshControl.endRefreshing()
    }
    
}

