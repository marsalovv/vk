
import Foundation

struct CommentsModel: Codable {
    
    let count: Int
    let items: [CommentModel]
}

struct CommentModel: Codable {

    let id: Int
    let fromID: Int
    let date: Int
    let text: String
    let thread: CommentsModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromID = "from_id"
        case date
        case text
        case thread
    }
}
