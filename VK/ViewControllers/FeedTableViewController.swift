
import UIKit
import SwiftyVK

class FeedTableViewController: UITableViewController {
    
    private  var posts: [PostModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .Pallete.white
        title = ~"feedTableViewController title"
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postTableViewCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: #selector(getNews))
        getNews()
    }
    
    @objc private func getNews() {
        print("getNews")
        VK.API.NewsFeed.get([.filters : "post, photo"])
            .onSuccess() {newsFeedData in
                guard let newsFeed = try? JSONDecoder().decode(NewsFeedModel.self, from: newsFeedData) else {
                    print("Ошибка парсинга")
                    return
                }
                self.posts = newsFeed.items
                print("otdali posty")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .onError({ error in
                print(error.localizedDescription)
            })
            .send()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! PostTableViewCell
        cell.setupCell(post: posts[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
        
}
