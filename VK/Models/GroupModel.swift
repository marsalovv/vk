
import Foundation

struct GroupModel: Codable {
    let id: Int
    let name: String
    let photo50: String
    let photo200: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo50 = "photo_50"
        case photo200 = "photo_200"
        case description
    }
}
