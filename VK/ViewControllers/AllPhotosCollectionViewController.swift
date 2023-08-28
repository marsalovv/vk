
import UIKit
import SwiftyVK

final class AllPhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "photo"
    private var photos: [PhotoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        title = "Фото"
        
        getPhotos()
    }
    
    private func getPhotos() {
        VK.API.Photos.getAll([.photoSizes: "1"])
            .onSuccess() {photosData in
                guard let allPhotosModel = try? JSONDecoder().decode(AllPhotosModel.self, from: photosData) else {return}
                
                self.photos = allPhotosModel.items
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            .onError() {error in
                print(error.localizedDescription)
            }
            .send()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        let url = photo.sizes[0].url
        let date = photo.date
        let formater = CustomDateFormatter(dt: date)
        let dateString = formater.getDateAndTime()
        
        cell.setPhoto(url: url, date: dateString)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = photos[indexPath.row].sizes.last?.url else {return}
        let photoVC =  UINavigationController(rootViewController: PhotoViewController(url: url))
        present(photoVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = 100
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        24
    }
    
}
