
import UIKit
import SwiftyVK

final class ProfileTableViewController: UITableViewController {
    
    private var posts: [PostModel] = []
    private var profile: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .Pallete.white
        title = ~"profile"
        
        tableView.register(ProfileInfoTableViewCell.self, forCellReuseIdentifier: "profileInfo")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        tableView.estimatedRowHeight = 300
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(pushCPVC))
        navigationItem.rightBarButtonItem?.accessibilityLabel = ~"create post"
        
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
    
    private func getProfile() {
        VK.API.Users.get([.fields : "photo_400_orig,status"])
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
        VK.API.Wall.get([.filter : "post"])
            .onSuccess() {postsData in
                guard let newPosts = try? JSONDecoder().decode(PostsModel.self, from: postsData) else {return}
                
                self.posts = newPosts.items
                
                DispatchQueue.main.async {
                    self.posts = []
                    self.tableView.reloadData()
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
            deletePost(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

