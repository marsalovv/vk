
import UIKit
import SwiftyVK

class FeedTableViewController: UITableViewController {
    
    private  var posts: [NewsModel] = []
    private var nextFrom: String = ""
    
    private lazy var loadIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .Pallete.white
        title = ~"feedTableViewController"
        
        view.addSubview(loadIndicatorView)
        loadIndicatorView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
        loadIndicatorView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension;
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(pushCVC))
        navigationItem.rightBarButtonItem?.accessibilityLabel = ~"create post"
        
        getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func pushCVC() {
        let CPVC = UINavigationController(rootViewController: CreatingPostViewController())
        self.present(CPVC, animated: true)
    }
    
    @objc private func getNews() {
        loadIndicatorView.startAnimating()
        VK.API.NewsFeed.get([.filters : "post", .startFrom : nextFrom, .count : "25"])
            .onSuccess() {newsFeedData in
                guard let newsFeed = try? JSONDecoder().decode(NewsFeedModel.self, from: newsFeedData) else {return}
                self.posts += newsFeed.items
                self.nextFrom = newsFeed.nextFrom
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.loadIndicatorView.stopAnimating()
                }
            }
            .onError({ error in
                print(error.localizedDescription)
            })
            .send()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! PostTableViewCell
        
        cell.postImageView.image = nil
        cell.setupCell(post: posts[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= posts.count - 3 {
            getNews()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postVC = PostViewController(post: posts[indexPath.row])
        navigationController?.pushViewController(postVC, animated: true)

        
    }
    
}
