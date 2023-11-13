
import UIKit
import SwiftyVK

final class ProfileTableViewController: UITableViewController {
    
    private var posts: [PostModel] = []
    private let userId: String
    private var profile: ProfileModel?
    
init(userId: String = "") {
        self.userId = userId
    super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userId.isEmpty {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: ~"logout", style: .plain, target: self, action: #selector(logout))
        }
        view.backgroundColor = .Pallete.white
        title = ~"profile"
        
        tableView.register(ProfileInfoTableViewCell.self, forCellReuseIdentifier: "profileInfo")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(pushCPVC))
        navigationItem.rightBarButtonItem?.accessibilityLabel = ~"create post"
        
        //tabBarController?.tabBar.isHidden = false
        getProfile()
        getPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func pushCPVC() {
        let cpvc = CreatingPostViewController()
        cpvc.action = {
                        self.getPosts()
            self.tableView.scrollToRow(at: IndexPath(item: 1, section: 0), at: .top, animated: true)
        }
        
        let createPostVC = UINavigationController(rootViewController: cpvc)
        present(createPostVC, animated: true)
    }
    
    @objc private func logout() {
        VK.sessions.default.logOut()
        VK.release()

        UserDefaults.standard.setValue(nil, forKey: "token")
        
        let loginVC = LoginViewController()
        navigationController?.popViewController(animated: true)
        navigationController?.viewControllers = [loginVC]
    }
    
    private func getProfile(){
        let id = Int(userId) ?? 0
        if id < 0 {
            VK.API.Groups.getById([.groupId : String(-id), .fields: "status,description"])
                .onSuccess() {data in
                    guard let groups = try? JSONDecoder().decode([GroupModel].self, from: data) else {return}
                    
                    let group = groups[0]
                    
                    let groupProfile = ProfileModel(id: group.id, firstName: group.name, lastName: "", isClosed: nil, status: group.status, isFriend: nil, photo50: nil, photo100: nil, photo200Orig: group.photo200, description: group.description)
                    
                    self.profile = groupProfile
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                .send()
            return
        }
            

        VK.API.Users.get([.fields: "photo_200_orig,status", .userId: userId])
            .onSuccess() {usersData in
                guard let users = try? JSONDecoder().decode([ProfileModel].self, from: usersData) else {return}
                
                self.profile = users[0]
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .onError() {error in
                print(error.localizedDescription)
            }
            .send()
    }
    
    private func getPosts() {
        VK.API.Wall.get([.filter : "post", .ownerId: userId])
            .onSuccess() {postsData in
                guard let newPosts = try? JSONDecoder().decode(PostsModel.self, from: postsData) else {print("11111");return}
                
                self.posts = newPosts.items
                
                DispatchQueue.main.async {
                    self.posts = newPosts.items
                    self.tableView.reloadData()
                }
            }
            .onError() {error in
                print(error.localizedDescription)
            }
            .send()
    }
    
    private func deletePost(indexPath: IndexPath) {
        let index = indexPath.row - 1
        let ownerId = posts[index].ownerID ?? 0
        let postId = posts[index].id ?? 0
        VK.API.Wall.delete([.ownerId: String(ownerId), .postId: String(postId)])
            .onSuccess() {_ in
                DispatchQueue.main.async {
                    let myIndexPath = IndexPath(row: index + 1, section: 0)
                    self.posts.remove(at: index)
                    self.tableView.deleteRows(at: [myIndexPath], with: .top)
                    self.tableView.reloadData()
                }
            }
            .onError() {error in
                print(error.localizedDescription)
            }
            .send()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfo", for: indexPath) as! ProfileInfoTableViewCell
            
            if let myProfile = profile {
                cell.setupCell(profile: myProfile)
            }
            
            cell.isUserInteractionEnabled = false
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
            cell.postImageView.image = nil
            
            cell.setupCell(post: posts[indexPath.row - 1])
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        
        let ptvc = PostViewController(post: posts[indexPath.row - 1])
        navigationController?.pushViewController(ptvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }else{
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let alert = UIAlertController(
                title: ~"delete post",
                message: ~"Confirmation of post deletion",
                preferredStyle: .actionSheet
            )
            
            let deleteAaction = UIAlertAction(title: ~"yes", style: .destructive) {_ in
                self.deletePost(indexPath: indexPath)
            }
            let cansellAction = UIAlertAction(title: ~"cancel", style: .cancel)
            alert.addAction(deleteAaction)
            alert.addAction(cansellAction)
            
            navigationController?.present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

