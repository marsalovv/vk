
import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        setupConstraints()
        self.isAccessibilityElement = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhoto(url: String, date: String) {
        guard let imageUrl = URL(string: url) else {return}
        imageView.sd_setImage(with: imageUrl)
        
        self.accessibilityLabel = date
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
}
