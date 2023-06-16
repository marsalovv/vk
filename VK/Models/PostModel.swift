
import Foundation

struct PostModel: Codable {
    let type: String
    let text: String?
    let date: Double
    let postID: Int
    let likes: Likes?
    let comments: Comment?
    let attachments: [Attachment]?
    let photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case date
        case postID = "post_id"
        case likes
        case comments
        case  attachments
        case photos
    }
}

struct Likes: Codable{
    let count: Int?
    let userLikes: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
}

struct Comment: Codable {
    let count: Int
}

struct Attachment: Codable {
    let type: String?
    let photo: PhotoNewsModel?
}

struct Photo:Codable{
    let id: Int
    let src: String
    let src_big: String
}
