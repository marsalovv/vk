
import UIKit
import SwiftyVK

class LoginViewController: UIViewController, SwiftyVKDelegate {
    
    private let color = UIColor(patternImage: UIImage(named: "LoginViewControllerBackground")!)
    
    private lazy var image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "LoginViewControllerBackground")!)
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label .text = ~"login label"
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.textColor = .white
        
        label.textAlignment = .center
        label.shadowColor = color
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.borderColor = color.cgColor
        btn.layer.borderWidth = 3
        btn.layer.cornerRadius = 15
        btn.setTitle(~"login button", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        btn.setTitleColor(color, for: .normal)
        btn.addTarget(target, action: #selector(login), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = color
        
        view.addSubview(image)
        image.addSubview(label)
        image.addSubview(loginButton)
        
        setupConstraints()
    }
    
    @objc private func login() {
        VK.setUp(appId: "51674921", delegate: self)
        
        VK.sessions.default.logIn(onSuccess: { responce in
            UserDefaults.standard.setValue(responce["access_token"], forKey: "token")
            
            DispatchQueue.main.async {
                let mtbc = MainTabBarController()
                self.navigationController?.viewControllers = [mtbc]
            }
        },
                                  onError: { error in
            print(error.localizedDescription)
        })
    }
    
    private func setupConstraints() {
        let height = UIScreen.main.bounds.height
        let safeArie = view.safeAreaLayoutGuide
        image.topAnchor.constraint(equalTo: safeArie.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: safeArie.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: safeArie.trailingAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: safeArie.bottomAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -16).isActive = true
        label.heightAnchor.constraint(equalToConstant: height / 5).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 50).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -50).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -100).isActive = true
    }
    
    //MARK: - SwiftyVKDelegate
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        let scopes: Scopes = [ .friends, .photos, .wall, .status, .audio, .offline, .groups]
        
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        // Called when SwiftyVK wants to present UI (e.g. webView or captcha)
        // Should display given view controller from current top view controller
        
        present(viewController, animated: true)
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        // Called when user grants access and SwiftyVK gets new session token
        // Can be used to run SwiftyVK requests and save session data
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        // Called when existing session token has expired and successfully refreshed
        // You don't need to do anything special here
    }
    
    func vkTokenRemoved(for sessionId: String) {
        // Called when user was logged out
        // Use this method to cancel all SwiftyVK requests and remove session data
    }
    
}

