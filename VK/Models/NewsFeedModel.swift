
import Foundation

struct NewsFeedModel: Codable {
    let items: [NewsModel]
    let profiles: [ProfileModel]
    let nextFrom: String
    
    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case nextFrom = "next_from"
    }
}
