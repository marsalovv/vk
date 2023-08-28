


struct NewsModel: Codable, PostProtocol {
    
    var id: Int?
    
    var ownerID: Int?
    
    var fromID: Int?
    
    let date: Int
    let sourceID: Int?
    let postID: Int?
    let text: String?
    let likes: Like?
    let comments: CountComments?
    let attachments: [Attachment]?
    
    enum CodingKeys: String, CodingKey {
        case date
        case sourceID = "source_id"
        case postID = "post_id"
        case text
        case likes
        case comments
        case  attachments
    }
}

struct Like: Codable{
    let count: Int?
    let userLikes: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
}

struct CountComments: Codable {
    let count: Int
}

struct Attachment: Codable {
    let type: String?
    let photo: PhotoModel?
}

