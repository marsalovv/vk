
import UIKit
import SwiftyVK

class CommentTableViewCell: UITableViewCell {

    
    private lazy var avatarImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [nameLabel, dateLabel, commentLabel, avatarImageView].forEach({contentView.addSubview($0)})
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(ownerId: Int, date: Int, comment: String) {
        let dateFormater = CustomDateFormatter(dt: date)
        dateLabel.text = dateFormater.getDateAndTime()
        
        commentLabel.text = comment
        
setNameAndAvatar(id: ownerId)
    }
    
    private func setNameAndAvatar(id: Int) {
        if id < 0 {
            VK.API.Groups.getById([.groupId : String(-id)])
                .onSuccess() {data in
                    guard let groups = try? JSONDecoder().decode([GroupModel].self, from: data) else {return}
                    
                    let group = groups[0]
                    let name = group.name
                    let image = group.photo50
                    
                    DispatchQueue.main.async {
                        self.nameLabel.text = name
                        self.avatarImageView.sd_setImage(with: URL(string: image))
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
                    let image = users[0].photo50 ?? ""
                    
                    DispatchQueue.main.async {
                        self.nameLabel.text = name
                        self.avatarImageView.sd_setImage(with: URL(string: image))
                    }
                }
                .onError() {error in
                    print(error.localizedDescription)
                }
                .send()
        }
    }

    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            commentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            commentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            commentLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -8),
            
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            dateLabel.heightAnchor.constraint(equalToConstant: 16),
            
            
        ])
    }
}
