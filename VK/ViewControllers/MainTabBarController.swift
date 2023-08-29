
import UIKit
import SwiftyVK

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let swiftyVKDelegate = LoginViewController()
        VK.setUp(appId: "51674921", delegate: swiftyVKDelegate)
        
 let feedTVC = UINavigationController(rootViewController: FeedTableViewController())
        feedTVC.tabBarItem = UITabBarItem(title: ~"feedTableViewController", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let profileTVC = UINavigationController(rootViewController: ProfileTableViewController())
        profileTVC.tabBarItem = UITabBarItem(title: ~"profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        
        let layout = UICollectionViewFlowLayout()
        let allPhotoCVC = UINavigationController(rootViewController: AllPhotosCollectionViewController(collectionViewLayout: layout))
        allPhotoCVC.tabBarItem = UITabBarItem(title: ~"photo", image: UIImage(systemName: "photo"), selectedImage: UIImage(systemName: "photo.fill"))
        
        viewControllers = [ feedTVC, allPhotoCVC, profileTVC]
    }
    
    
}
