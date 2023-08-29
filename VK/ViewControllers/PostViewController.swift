
import UIKit
import SwiftyVK
import SDWebImage

final class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var comments: [CommentModel] = []
    private let post: PostProtocol
    private var ownerId: String = ""
    private var postId: String = ""
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 16
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        button.configuration = config
        button.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        button.setImage(UIImage(systemName: "paperplane.circle.fill"), for: .normal)
        button.layer.cornerRadius = UIScreen.main.bounds.height / 40
        button.clipsToBounds = true
        button.accessibilityLabel = ~"send"
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(post: PostProtocol) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
        
        setId()
        getComments()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ~"post"
        view.backgroundColor = .Pallete.white
        
        [tableView, commentTextView, sendButton].forEach({view.addSubview($0)})
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "comment")
        tableView.estimatedRowHeight = 300
        
        view.backgroundColor = .Pallete.white
        tabBarController?.tabBar.isHidden = true
        
        setupConstraints()
    }
    
    private func setId() {
        if let id = post.sourceID{
            ownerId = String(id)
        }
        if let id = post.ownerID {
            ownerId = String(id)
        }
        if let id = post.postID {
            postId = String(id)
        }
        if let id = post.id {
            postId = String(id)
        }
    }
    
    @objc private func sendComment() {
        if commentTextView.text.isEmpty {
            return
        }
        
        let comment = commentTextView.text
        
        VK.API.Wall.createComment([.ownerId: ownerId, .postId: postId, .message: comment])
            .onSuccess() {_ in
                self.getComments()
                DispatchQueue.main.async {
                    self.commentTextView.text = nil
                }
            }
            .onError() {error in
                print("123123", error.localizedDescription)
                print(self.ownerId, self.postId)
            }
            .send()
    }
    
    private func getComments(commentId: String = "") {
        VK.API.Wall.getComments([.ownerId: ownerId, .postId: postId, .count: "100", .commentId: commentId])
            .onSuccess() { [self]commentsData in
                guard var newComments = try? JSONDecoder().decode(CommentsModel.self, from: commentsData) else {return}
                
                if commentId.isEmpty != true {
                    for index in 0..<newComments.items.count {
                        newComments.items[index].isReply = true
                    }
                    let indexThread = comments.firstIndex(where: {String($0.id) == commentId})! + 1
                    comments.insert(contentsOf: newComments.items, at: indexThread)
                }
                
                for index in 0..<newComments.items.count {
                    let isReply = newComments.items[index].isReply ?? false
                    if isReply {
                        continue
                    }
                    
                    self.comments.append(newComments.items[index])
                    
                    let count = newComments.items[index].thread?.count ?? 0
                    if count > 0{
                        let threadId = String(self.comments[index].id)
                        self.getComments(commentId: threadId)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .onError() {error in
                print(error.localizedDescription)
            }
            .send()
    }
    
    private func setupConstraints() {
        let safearie = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safearie.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safearie.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safearie.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentTextView.topAnchor),
            
            commentTextView.leadingAnchor.constraint(equalTo: safearie.leadingAnchor, constant: 8),
            commentTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -4),
            commentTextView.heightAnchor.constraint(equalToConstant: 50),
            commentTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.trailingAnchor.constraint(equalTo: safearie.trailingAnchor, constant: -4),
            sendButton.centerYAnchor.constraint(equalTo: commentTextView.centerYAnchor),
        ])
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
            
            cell.setupCell(post: post)
            cell.postLabel.numberOfLines = 0
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentTableViewCell
            
            let comment = comments[indexPath.row - 1]
            let ownerId = comment.fromID
            let date = comment.date
            let message = comment.text
            let isReply = comment.isReply ?? false
            
            cell.setupCell(ownerId: ownerId, date: date, comment: message, isReply: isReply)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
