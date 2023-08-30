
import UIKit
import SwiftyVK
import PhotosUI

final class CreatingPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let imagePicker = UIImagePickerController()
    var action: (() -> ()) = {}
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .Pallete.black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle(~"send post", for: .normal)
        button.addTarget(self, action: #selector(sendPost), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 8
        image.isHidden = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [textView, addImageButton, sendButton, imageView].forEach({view.addSubview($0)})
        title = ~"create post"
        view.backgroundColor = .Pallete.white
        
        imagePicker.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(sendPost))
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @objc private func sendPost() {
        if textView.text.isEmpty && imageView.image == nil {
            return
        }
        
        let message = textView.text
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
            VK.API.Upload.Photo.toWall(.image(data: data, type: .jpg), to: .user(id: userId))
                .chain() {photosIdData in
                    let photos = try JSONDecoder().decode([MediaID].self, from: photosIdData)
                    let photoId = photos[0].id
                    
                    return VK.API.Wall.post([
                        .message: message,
                        .attachments: "photo\(userId)_\(photoId)"
                    ])
                }
                .onSuccess() {_ in
                    DispatchQueue.main.async {
                        self.action()
                    }
                }
                .onError() {error in
                    print(error.localizedDescription)
                }
                .send()
        }else{
            VK.API.Wall.post([.message: message])
                .onSuccess() {_ in
                    DispatchQueue.main.async {
                        self.action()
                    }
                }
                .onError() {error in
                    print(error.localizedDescription)
                }
                .send()
        }
        
        dismiss(animated: true)
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func selectImage() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) {status in
            switch status{
            case .authorized:
                DispatchQueue.main.async {
                    self.showPicker()
                }
            case .limited:
                DispatchQueue.main.async {
                    self.showPicker()
                }
                
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func showPicker() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    private func setupConstraints() {
        let safearie = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safearie.topAnchor, constant: 24),
            textView.leadingAnchor.constraint(equalTo: safearie.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safearie.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: addImageButton.topAnchor, constant: -16),
            
            addImageButton.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 20),
            addImageButton.heightAnchor.constraint(equalToConstant: 50),
            addImageButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -8),
            
            imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: addImageButton.trailingAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
            sendButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -16),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    //MARK: - UIPickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imageView.isHidden = false
        }
        dismiss(animated: true, completion: nil)
    }
    
}
