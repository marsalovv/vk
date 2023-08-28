
import UIKit
import SDWebImage
import SwiftyVK

class PhotoViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image .translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.setTitle(~"close", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.sd_setImage(with: URL(string: url))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.addSubview(closeButton)
        view.addSubview(imageView)

        setupConstraints()
    }
    
    @objc private func close() {
        print("close")
        dismiss(animated: true)
    }
    
    private func setupConstraints() {
        let safeArie = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArie.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeArie.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeArie.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeArie.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 12),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
}
