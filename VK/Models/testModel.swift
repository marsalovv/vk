
struct TestModel: Codable, PostProtocol {
    var date: Int
    
    var sourceID: Int?
    
    var postID: Int?
    
    var text: String?
    
    var likes: Like?
    
    var comments: CountComments?
    
    var attachments: [Attachment]?
    
    var id: Int?
    
    var ownerID: Int?
    
    var fromID: Int?
    
    
}
