import Foundation

class NoteModel: Codable  {
    let uuid: String
    let title: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case uuid, title, content
    }

    init(uuid: String = UUID().uuidString, title: String?, content: String?) {
        assert(uuid != "", "uuid should not be empty")
        self.uuid = uuid
        self.title = title
        self.content = content
    }

    convenience init(title: String, content: String){
        let uuid = UUID().uuidString
        self.init(uuid: uuid, title: title, content: content)
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let uuid = try container.decode(String.self, forKey: .uuid)
        let title = try container.decode(String.self, forKey: .title)
        let content = try container.decode(String.self, forKey: .content)

        self.init(uuid: uuid, title: title, content: content)
    }

}
