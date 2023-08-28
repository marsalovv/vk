
struct UploadURLPhotoModel: Codable {
    let albumID: Int
    let uploadURL: String
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case uploadURL = "upload_url"
        case userID = "user_id"
    
    }
}
