
import Foundation

struct PhotoModel: Codable {
    let id: Int
    let ownerID: Int
    let date: Int
    let sizes: [PhotoSizes]
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case date
        case sizes

    }
}

struct PhotoSizes: Codable {
    let type: String
    let url: String
}


