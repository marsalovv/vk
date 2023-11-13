
import UIKit
import SDWebImage

final class ProfileInfoTableViewCell: UITableViewCell {
    
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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .Pallete.white
        [avatarImageView, NameLabel, statusLabel, descriptionLabel].forEach() {contentView.addSubview($0)}
        setupConstraints()
        self.accessibilityElements = [avatarImageView, NameLabel, statusLabel, descriptionLabel]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(profile: ProfileModel) {
        NameLabel.text = "\(profile.firstName) \(profile.lastName)"
        statusLabel.text = profile.status
        descriptionLabel.text = profile.description
        avatarImageView.sd_setImage(with: URL(string: profile.photo200Orig!))
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
            statusLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8),
            statusLabel.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
}
