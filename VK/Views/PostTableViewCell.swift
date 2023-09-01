
import UIKit
import SwiftyVK
import SDWebImage

final class PostTableViewCell: UITableViewCell {
    
    var imageHeight: CGFloat = 0
    private var isUserLike: Bool = false
    private var likesCount: Int = 0
    private var ownerId: String = ""
    private var itemId: String = ""
    private let type: String = "post"
    
    private lazy var authorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let postImageView: UIImageView = {
        let image = UIImageView()
        image.isAccessibilityElement = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var likesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(addOrRemoveLike), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var commentsButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(systemName: "bubl.left"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [authorLabel, avatarImageView, dateLabel].forEach({authorView.addSubview($0)})
        [authorView,postImageView, postLabel, likesButton, commentsButton].forEach {contentView.addSubview($0)}
        self.accessibilityElements = [authorLabel, postLabel, postImageView,likesButton, commentsButton]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(post: PostProtocol) {
        
        imageHeight = 0
        
        postLabel.text = post.text
        
        likesCount = post.likes?.count ?? 0
        likesButton.setTitle("\(likesCount)", for: .normal)
        isUserLike = post.likes?.userLikes == 1 ? true : false
        likesButton.isSelected = isUserLike
        
        if let id = post.sourceID{
            ownerId = String(id)
        }
        if let id = post.ownerID {
            ownerId = String(id)
        }
        if let id = post.postID {
            itemId = String(id)
        }
        if let id = post.id {
            itemId = String(id)
        }
        
        let formater = CustomDateFormatter(dt: post.date)
        dateLabel.text = formater.getDateAndTime()
        
        if let comments = post.comments?.count {
            commentsButton.setTitle("\(comments)", for: .normal)
            if comments == 0 {
                commentsButton.setImage(UIImage(systemName: "bubble.left"), for: .normal)
            }else{
                commentsButton.setImage(UIImage(systemName: "bubble.left.fill"), for: .normal)
            }
        }
        
        let id = Int(ownerId) ?? 0
        setNameAndAvatar(id: id)
        
        guard let attachments = post.attachments else {
            setupConstraints()
            return
        }
        
        if attachments.count == 0 {
            setupConstraints()
            return
        }
        
        for attachment in attachments{
            if attachment.type == "photo" {
                guard let url = attachment.photo?.sizes.first?.url else {return}
                
                imageHeight = UIScreen.main.bounds.height / 3
                postImageView.sd_setImage(with: URL(string: url))
                postLabel.numberOfLines = 8
                setupConstraints()
            }
        }
    }
    
    private func setNameAndAvatar(id: Int) {
        if id < 0 {
            VK.API.Groups.getById([.groupId : String(-id)])
                .onSuccess() {data in
                    guard let groups = try? JSONDecoder().decode([GroupModel].self, from: data) else {return}
                    
                    let group = groups[0]
                    let name = group.name
                    let imageUrl = group.photo50
                    
                    DispatchQueue.main.async {
                        self.authorLabel.text = name
                        self.avatarImageView.sd_setImage(with: URL(string: imageUrl))
                        
                        let date = self.dateLabel.text ?? ""
                        self.authorLabel.accessibilityLabel = "\(name), \(date)"
                    }
                }
                .onError() {error in
                    print(error.localizedDescription)
                }
                .send()
        }else{
            VK.API.Users.get([.userIDs : String(id), .fields : "photo_50"])
                .onSuccess() {usersData in
                    guard let users = try? JSONDecoder().decode([ProfileModel].self, from: usersData) else {return}
                    
                    let name = "\(users[0].firstName) \(users[0].lastName)"
                    let imageUrl = users[0].photo50 ?? ""
                    
                    DispatchQueue.main.async {
                        self.authorLabel.text = name
                        self.avatarImageView.sd_setImage(with: URL(string: imageUrl))
                        
                        let date = self.dateLabel.text ?? ""
                        self.authorLabel.accessibilityLabel = "\(name), \(date)"
                    }
                }
                .onError() {error in
                    print(error.localizedDescription)
                }
                .send()
        }
    }
    
    @ objc private func addOrRemoveLike() {
        if isUserLike == false {
            VK.API.Likes.add([.type: type, .ownerId: ownerId, .itemId: itemId])
                .onSuccess() {_ in
                    DispatchQueue.main.async {
                        self.likesButton.isSelected = true
                        self.likesCount += 1
                        self.likesButton.setTitle("\(self.likesCount)", for: .selected)
                        self.isUserLike = true
                    }
                }
                .send()
        }else{
            VK.API.Likes.delete([.type: type, .ownerId: ownerId, .itemId: itemId])
                .onSuccess() {_ in
                    DispatchQueue.main.async {
                        self.likesButton.isSelected = false
                        self.likesCount -= 1
                        self.likesButton.setTitle("\(self.likesCount)", for: .normal)
                        self.isUserLike = false
                    }
                }
                .send()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            authorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            authorView.heightAnchor.constraint(equalToConstant: 70),
            
            avatarImageView.topAnchor.constraint(equalTo: authorView.topAnchor, constant: 4),
            avatarImageView.leadingAnchor.constraint(equalTo: authorView.leadingAnchor, constant: 4),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            
            authorLabel.topAnchor.constraint(equalTo: authorView.topAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: authorView.bottomAnchor, constant: -8),
            
            postLabel.topAnchor.constraint(equalTo: authorView.bottomAnchor, constant: 12),
            postLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postLabel.bottomAnchor.constraint(equalTo: postImageView.topAnchor, constant: -8),
            
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            postImageView.bottomAnchor.constraint(equalTo: likesButton.topAnchor, constant: -16),
            
            likesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            commentsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commentsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

        ])
    }
    
}

