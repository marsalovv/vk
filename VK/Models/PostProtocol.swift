
protocol PostProtocol {
    var date: Int {get}
    var sourceID: Int? {get}
    var postID: Int? {get}
    var text: String? {get}
    var likes: Like? {get}
    var comments: CountComments? {get}
    var attachments: [Attachment]? {get}
    var id: Int? {get}
    var ownerID: Int? {get}
    var fromID: Int? {get}
}
