import UIKit

protocol AddViewControllerDelegate {
  func didFinishTyping(text: String?)
}

class AddViewController: UIViewController {
  var textField: UITextField?
  var newItemText: String?
  var delegate: AddViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    setupTextField()
    setupNavigationBar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    textField?.becomeFirstResponder()
  }
  
  func setupTextField() {
    textField = UITextField(frame: .zero)
    textField?.placeholder = "Type in item"
    textField?.delegate = self
    view.addSubview(textField!)
  }
  
  func setupNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                        target: self,
                                                        action: #selector(AddViewController.doneAction))
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    textField?.frame = CGRect(x: 11,
                              y: self.topLayoutGuide.length + 50,
                              width: view.frame.size.width - 22,
                              height: 100)
  }
  
  func doneAction() {
    delegate?.didFinishTyping(text: textField?.text)
    dismiss(animated: true, completion: nil)
  }
}

extension AddViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    doneAction()
    textField.resignFirstResponder()
    return true
  }
  
}
