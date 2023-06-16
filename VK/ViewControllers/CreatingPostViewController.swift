
import UIKit

class CreatingPostViewController: UIViewController {
    
    private var keyboardHeight : CGFloat = 0


    private lazy var textView: UITextView = {
        let textView = UITextView()

        textView.textColor = .Pallete.black
        textView.font = UIFont.systemFont(ofSize: 30)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textView)
        title = ~"create post"
        view.backgroundColor = .Pallete.white
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancel))
    }
    
    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setupConstraints() {
        let safearie = self.view.safeAreaLayoutGuide
        
        textView.topAnchor.constraint(equalTo: safearie.topAnchor, constant: 10).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: safearie.bottomAnchor, constant: -keyboardHeight - 20).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @objc   func   keyboardWillShow(notification: NSNotification) {
        if   let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?   NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
            setupConstraints()
        }
    }
    
}

