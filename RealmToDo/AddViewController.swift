import UIKit

protocol AddViewControllerDelegate {
    func didFinishTypingText(typedText: String?)
}

class AddViewController: UIViewController, UITextFieldDelegate {
    var textField: UITextField?
    var newItemText: String?
    var delegate: AddViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setupTextField()
        setupNavigationBar()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textField?.becomeFirstResponder()
    }

    func setupTextField() {
        textField = UITextField(frame: CGRectZero)
        textField?.placeholder = "Type in item"
        textField?.delegate = self
        view.addSubview(textField!)
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneAction")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField?.frame = CGRectMake(11, self.topLayoutGuide.length + 50, view.frame.size.width - 22, 100)
    }

    func doneAction() {
        delegate?.didFinishTypingText(textField?.text)
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        doneAction()
        textField.resignFirstResponder()
        return true
    }

}