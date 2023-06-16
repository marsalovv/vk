
import UIKit
import SwiftyVK

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swiftyVKDelegate = LoginViewController()
        VK.setUp(appId: "51674921", delegate: swiftyVKDelegate)
        
 let feedTVC = UINavigationController(rootViewController: FeedTableViewController())
        feedTVC.tabBarItem = UITabBarItem(title: ~"feedTableViewController tabBarItem", image: UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper.fill"))

        
        
        viewControllers = [feedTVC]
    }
    
}
