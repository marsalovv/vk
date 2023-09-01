
import UIKit
import SDWebImage

final class ProfileInfoTableViewCell: UITableViewCell {
    
    private lazy var NameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Pallete.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Pallete.black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 75
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.clipsToBounds = true
        image.isAccessibilityElement = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .Pallete.white
        [avatarImageView, NameLabel, statusLabel].forEach() {contentView.addSubview($0)}
        setupConstraints()
        self.accessibilityElements = [avatarImageView, NameLabel, statusLabel]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints () {
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            
            NameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 40),
            NameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            NameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            statusLabel.topAnchor.constraint(equalTo: NameLabel.bottomAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func setupCell(profile: ProfileModel) {
        NameLabel.text = "\(profile.firstName) \(profile.lastName)"
        statusLabel.text = profile.status
        avatarImageView.sd_setImage(with: URL(string: profile.photo400Orig!))
        
    }
    
}
