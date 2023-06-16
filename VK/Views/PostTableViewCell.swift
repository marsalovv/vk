
import UIKit
import SwiftyVK
import SDWebImage

final class PostTableViewCell: UITableViewCell {
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 6
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.isAccessibilityElement = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var likesButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("likes", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var commentsButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("comments", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(post: PostModel) {
        if let text = post.text {
            postLabel.text = text
        }else{
            postLabel.isHidden = true
        }
        
        if let likes = post.likes?.count{
            likesButton.setTitle("likes: \(likes)", for: .normal)
        }
        
        if let comments = post.comments?.count {
            commentsButton.setTitle("comments: \(comments)", for: .normal)
        }
        
        guard let attachments = post.attachments else {return}

        for attachment in attachments{
            guard let url = attachment.photo?.sizes?.last?.url else {return}
            image.sd_setImage(with: URL(string: url))
        }
    }
    
    private func setupConstraints() {
        [image, postLabel, likesButton, commentsButton].forEach {contentView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            postLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            postLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postLabel.heightAnchor.constraint(equalToConstant: 160),
            
            
            image.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 200),
            image.bottomAnchor.constraint(equalTo: likesButton.topAnchor, constant: -16),
            
            likesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            commentsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            commentsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
