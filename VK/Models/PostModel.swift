
struct PostModel: Codable, PostProtocol {
    var sourceID: Int?
    var postID: Int?
    let id: Int?
    let ownerID: Int?
    let fromID: Int?
    let date: Int
    let text: String?
    let likes: Like?
    let comments: CountComments?
    let views: viewsModel?
    let attachments: [Attachment]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case fromID = "from_id"
        case date
        case text
        case likes
        case comments
        case views
        case attachments
    }
}
