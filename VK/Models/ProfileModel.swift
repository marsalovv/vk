
import Foundation

struct ProfileModel: Codable {
    let id: Int
    var firstName: String
    var lastName: String
    let isClosed: Bool?
    var status: String?
    let isFriend: Int?
    let photo50: String?
    let photo100: String?
    let photo200Orig: String?
    var photo400Orig: String?
    let description: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case status
        case isFriend = "is_friend"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200Orig = "photo_200_orig"
        case photo400Orig = "photo_400_orig"
        case description
        
    }
}
