
import Foundation

struct ProfileModel: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let isClosed: Bool
    let status: String?
    let isFriend: Int?
    let photo50: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case status
        case isFriend = "is_friend"
        case photo50 = "photo_50"
        
    }
}
