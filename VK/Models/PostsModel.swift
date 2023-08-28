import Foundation

struct PostsModel: Codable {
    let count: Int
    let items: [PostModel]
}
